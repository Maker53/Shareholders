//
//  SUT: OfficeChangingInteractor
//
//  Collaborators:
//  OfficeChangingProvider
//  OfficeChangingPresenter

import AlfaNetworking
import TestAdditions

@testable import CardReissue

final class OfficeChangingInteractorTests: QuickSpec {
    override func spec() {
        var interactor: OfficeChangingInteractor!
        var providerMock: OfficeChangingProviderMock!
        var presenterMock: OfficeChangingPresenterMock!
        var updateServiceMock: OfficeChangingUpdateServiceMock!

        beforeEach {
            providerMock = OfficeChangingProviderMock()
            presenterMock = OfficeChangingPresenterMock()
            updateServiceMock = OfficeChangingUpdateServiceMock()
            interactor = OfficeChangingInteractor(
                cardID: TestData.cardID,
                presenter: presenterMock,
                provider: providerMock,
                updateOfficeService: updateServiceMock
            )
        }

        describe(".getCities") {
            it("should call provider") {
                // when
                interactor.getCities()
                // then
                expect(providerMock.getCitiesWasCalled).to(beCalledOnce())
            }

            context("when request is success") {
                it("should prepare empty city cell") {
                    providerMock.getCitiesStub = .value(TestData.cities)
                    // when
                    interactor.getCities()
                    // then
                    expect(presenterMock.presentCellsWasCalled).toEventually(beCalledOnce())
                    expect(presenterMock.presentCellsResponse?.items).toEventually(equal([TestData.emptyCityItem]))
                }
            }

            context("when request is failure") {
                it("should prepare error to present") {
                    providerMock.getCitiesStub = Promise(error: ServiceError.other)
                    // when
                    interactor.getCities()
                    // then
                    expect(presenterMock.presentCellsWasCalled).toEventuallyNot(beCalled())
                    expect(presenterMock.presentErrorWasCalled).toEventually(beCalledOnce())
                    expect(presenterMock.presentErrorArgument).toEventually(equal(OfficeChanging.ErrorType.emptyState))
                }
            }
        }

        describe(".openCitiesList") {
            it("should return city list") {
                // given
                providerMock.getCitiesStub = .value(TestData.cities)
                // when
                interactor.openCitiesList()
                // then
                expect(presenterMock.presentCitiesListWasCalled).toEventually(beCalledOnce())
                expect(presenterMock.presentCitiesListArguments?.itemsList).toEventually(equal(TestData.cities))
            }

            it("should return selected city") {
                // given
                providerMock.getCitiesStub = .value(TestData.unsortedCities)
                interactor.selectedCity = TestData.city
                // when
                interactor.openCitiesList()
                // then
                expect(presenterMock.presentCitiesListArguments?.selectedItemIndex).toEventually(equal(0))
            }
        }

        describe(".selectCity") {
            it("should invalidate cache") {
                // when
                interactor.selectCity(.init(index: 0))
                // then
                expect(providerMock.invalidateCacheWasCalled).to(beCalledOnce())
            }

            it("should not select city if it is unknown") {
                // given
                providerMock.getCitiesStub = .value(TestData.cities)
                // when
                interactor.selectCity(.init(index: 5))
                // then
                expect(interactor.selectedCity).to(beNil())
            }

            it("should select city") {
                // given
                providerMock.getCitiesStub = .value(TestData.cities)
                // when
                interactor.selectCity(.init(index: 0))
                // then
                expect(interactor.selectedCity).toEventually(equal(TestData.city))
            }

            it("should request metro list") {
                // given
                providerMock.getCitiesStub = .value(TestData.cities)
                providerMock.getMetroStub = .value(TestData.metroList)
                // when
                interactor.selectCity(.init(index: 0))
                // then
                expect(providerMock.getMetroWasCalled).toEventually(beCalledOnce())
            }

            it("should return error") {
                // given
                providerMock.getCitiesStub = .value(TestData.cities)
                providerMock.getMetroStub = Promise(error: ServiceError.other)
                // when
                interactor.selectCity(.init(index: 0))
                // then
                expect(presenterMock.presentErrorWasCalled).toEventually(beCalledOnce())
            }

            it("should invalidate metro and offices cache") {
                // given
                providerMock.getCitiesStub = .value(TestData.cities)
                // when
                interactor.selectCity(.init(index: 0))
                // then
                expect(providerMock.invalidateCacheWasCalled).to(beCalledOnce())
            }

            context("if metro list is not empty") {
                it("should call presenter") {
                    // given
                    providerMock.getCitiesStub = .value(TestData.cities)
                    providerMock.getMetroStub = .value(TestData.metroList)
                    // when
                    interactor.selectCity(.init(index: 0))
                    // then
                    expect(presenterMock.presentCellsWasCalled).toEventually(beCalledOnce())
                    expect(presenterMock.presentCellsResponse?.items)
                        .toEventually(equal(TestData.cityMetroItem))
                }
            }

            context("if metro list is empty") {
                it("should request offices") {
                    // given
                    providerMock.getCitiesStub = .value(TestData.cities)
                    providerMock.getMetroStub = .value([])
                    // when
                    interactor.selectCity(.init(index: 0))
                    // then
                    expect(providerMock.getOfficesWasCalled).toEventually(beCalledOnce())
                }

                it("should request offices") {
                    // given
                    providerMock.getCitiesStub = .value(TestData.cities)
                    providerMock.getMetroStub = .value([])
                    providerMock.getOfficesStub = .value(TestData.officesList)
                    // when
                    interactor.selectCity(.init(index: 0))
                    // then
                    expect(presenterMock.presentCellsWasCalled).toEventually(beCalledOnce())
                    expect(presenterMock.presentCellsResponse?.items)
                        .toEventually(equal(TestData.cityOfficeItem))
                }

                it("should return error") {
                    // given
                    providerMock.getCitiesStub = .value(TestData.cities)
                    providerMock.getMetroStub = .value([])
                    providerMock.getOfficesStub = Promise(error: ServiceError.other)
                    // when
                    interactor.selectCity(.init(index: 0))
                    // then
                    expect(presenterMock.presentErrorWasCalled).toEventually(beCalledOnce())
                }
            }
        }

        describe(".sortCities") {
            it("should return sorted cities") {
                // when
                let cities = interactor.sortCities(TestData.unsortedCities)
                // then
                expect(cities[0].name).to(equal(TestData.city.name))
                expect(cities[1].name).to(equal(TestData.peterburgCity.name))
                expect(cities[2].name).to(equal(TestData.kazanCity.name))
                expect(cities[3].name).to(equal(TestData.rostovCity.name))
            }
        }

        describe(".openMetroList") {
            it("should return metro list") {
                // given
                interactor.selectedCity = TestData.city
                providerMock.getMetroStub = .value(TestData.metroList)
                // when
                interactor.openMetroList()
                // then
                expect(presenterMock.presentMetroListWasCalled).toEventually(beCalledOnce())
                expect(presenterMock.presentMetroListArguments?.itemsList).toEventually(equal(TestData.metroList))
            }

            it("should return selected city") {
                // given
                providerMock.getMetroStub = .value(TestData.metroList)
                interactor.selectedCity = TestData.city
                interactor.selectedMetro = TestData.metro
                // when
                interactor.openMetroList()
                // then
                expect(presenterMock.presentMetroListArguments?.selectedItemIndex).toEventually(equal(0))
            }
        }

        describe(".selectMetro") {
            it("should not select metro if it is unknown") {
                // given
                providerMock.getMetroStub = .value(TestData.metroList)
                // when
                interactor.selectMetro(.init(index: 5))
                // then
                expect(interactor.selectedMetro).to(beNil())
            }

            it("should select metro") {
                // given
                providerMock.getMetroStub = .value(TestData.metroList)
                interactor.selectedCity = TestData.city
                // when
                interactor.selectMetro(.init(index: 0))
                // then
                expect(interactor.selectedMetro).toEventually(equal(TestData.metro))
            }

            it("should request offices list") {
                // given
                interactor.selectedCity = TestData.city
                providerMock.getMetroStub = .value(TestData.metroList)
                providerMock.getOfficesStub = .value(TestData.officesList)
                // when
                interactor.selectMetro(.init(index: 0))
                // then
                expect(providerMock.getOfficesWasCalled).toEventually(beCalledOnce())
            }

            it("should invalidate offices cache") {
                // given
                interactor.selectedCity = TestData.city
                providerMock.getMetroStub = .value(TestData.metroList)
                providerMock.getOfficesStub = .value(TestData.officesList)
                // when
                interactor.selectMetro(.init(index: 0))
                // then
                expect(providerMock.invalidateOfficesCacheWasCalled).to(beCalledOnce())
            }

            it("should return error") {
                // given
                interactor.selectedCity = TestData.city
                providerMock.getMetroStub = .value(TestData.metroList)
                providerMock.getOfficesStub = Promise(error: ServiceError.other)
                // when
                interactor.selectMetro(.init(index: 0))
                // then
                expect(presenterMock.presentErrorWasCalled).toEventually(beCalledOnce())
            }
        }

        describe(".openOffice") {
            it("should return metro list") {
                // given
                interactor.selectedCity = TestData.city
                providerMock.getOfficesStub = .value(TestData.officesList)
                // when
                interactor.openOfficesList()
                // then
                expect(presenterMock.presentOfficesListWasCalled).toEventually(beCalledOnce())
                expect(presenterMock.presentOfficesListArguments?.itemsList).toEventually(equal(TestData.officesList))
            }

            it("should return selected city") {
                // given
                providerMock.getOfficesStub = .value(TestData.officesList)
                interactor.selectedCity = TestData.city
                interactor.selectedMetro = TestData.metro
                interactor.selectedOffice = TestData.office
                // when
                interactor.openOfficesList()
                // then
                expect(presenterMock.presentOfficesListArguments?.selectedItemIndex).toEventually(equal(0))
            }
        }

        describe(".selectOffice") {
            it("should not select office if it is unknown") {
                // given
                interactor.selectedCity = TestData.city
                providerMock.getOfficesStub = .value(TestData.officesList)
                // when
                interactor.selectOffice(.init(index: 5))
                // then
                expect(interactor.selectedOffice).to(beNil())
            }

            it("should call provider with city") {
                // given
                interactor.selectedCity = TestData.city
                providerMock.getOfficesStub = .value(TestData.officesList)
                // when
                interactor.selectOffice(.init(index: 0))
                // then
                expect(providerMock.getOfficesWasCalled).to(beCalledOnce())
                expect(providerMock.getOfficesArguments.city).to(equal(TestData.city))
                expect(providerMock.getOfficesArguments.metro).to(beNil())
            }

            it("should call provider with city and metro") {
                // given
                interactor.selectedCity = TestData.city
                interactor.selectedMetro = TestData.metro
                providerMock.getOfficesStub = .value(TestData.officesList)
                // when
                interactor.selectOffice(.init(index: 0))
                // then
                expect(providerMock.getOfficesWasCalled).to(beCalledOnce())
                expect(providerMock.getOfficesArguments.city).to(equal(TestData.city))
                expect(providerMock.getOfficesArguments.metro).to(equal(TestData.metro))
            }

            it("should return city and office models") {
                // given
                interactor.selectedCity = TestData.city
                providerMock.getOfficesStub = .value(TestData.officesList)
                // when
                interactor.selectOffice(.init(index: 0))
                // then
                expect(presenterMock.presentCellsWasCalled).toEventually(beCalledOnce())
                expect(presenterMock.presentCellsResponse?.items).toEventually(equal(TestData.cityOfficeFullItem))
                expect(presenterMock.presentCellsResponse?.isConfirmationAvailable).toEventually(beTrue())
            }

            it("should return city, metro, office models") {
                // given
                interactor.selectedCity = TestData.city
                interactor.selectedMetro = TestData.metro
                providerMock.getOfficesStub = .value(TestData.officesList)
                // when
                interactor.selectOffice(.init(index: 0))
                // then
                expect(presenterMock.presentCellsWasCalled).toEventually(beCalledOnce())
                expect(presenterMock.presentCellsResponse?.items).toEventually(equal(TestData.fullItem))
                expect(presenterMock.presentCellsResponse?.isConfirmationAvailable).toEventually(beTrue())
            }
        }

        describe(".updateReissuesOffice") {
            it("should not call service if office is not selected") {
                // when
                interactor.updateReissuesOffice()
                // then
                expect(updateServiceMock.updateReissuesOfficeWasCalled).toNot(beCalled())
            }

            it("should not call service") {
                // given
                interactor.selectedOffice = TestData.office
                // when
                interactor.updateReissuesOffice()
                // then
                expect(updateServiceMock.updateReissuesOfficeWasCalled).to(beCalledOnce())
                expect(updateServiceMock.updateReissuesOfficeArguments?.0).to(equal(TestData.cardID))
                expect(updateServiceMock.updateReissuesOfficeArguments?.1).to(equal(TestData.office.number))
            }

            it("should call presenter") {
                // given
                interactor.selectedOffice = TestData.office
                updateServiceMock.updateReissuesOfficeStub = .success("")
                // when
                interactor.updateReissuesOffice()
                // then
                expect(presenterMock.presentUpdatedReissuesOfficeWasCalled).toEventually(beCalledOnce())
            }

            it("should return error") {
                // given
                let expectedError: OfficeChanging.ErrorType = .error(message: TestData.errorString)
                interactor.selectedOffice = TestData.office
                updateServiceMock.updateReissuesOfficeStub = .failure(.requestFailed(message: TestData.errorString))
                // when
                interactor.updateReissuesOffice()
                // then
                expect(presenterMock.presentErrorWasCalled).toEventually(beCalledOnce())
                expect(presenterMock.presentErrorArgument).toEventually(equal(expectedError))
            }
        }
    }
}

private extension OfficeChangingInteractorTests {
    enum TestData {
        static let city = City.Seeds.defaultModel
        static let cities = [city, city]
        static let emptyCityItem: OfficeChanging.PresentedCellType = .city(nil)
        static let unknownCity = City(uid: "9", name: "Toronto", path: "toronto")
        static let metro = Metro.Seeds.defaultModel
        static let metroList = [metro, metro]
        static let office = Office.Seeds.defaultModel
        static let officesList = [office, office]
        static let cityMetroItem: [OfficeChanging.PresentedCellType] = [.city(city), .metro(nil)]
        static let cityOfficeItem: [OfficeChanging.PresentedCellType] = [.city(city), .office(nil)]
        static let cityMetroOfficeItem: [OfficeChanging.PresentedCellType] = [.city(city), .metro(metro), .office(nil)]
        static let fullItem: [OfficeChanging.PresentedCellType] = [.city(city), .metro(metro), .office(office)]
        static let cityOfficeFullItem: [OfficeChanging.PresentedCellType] = [.city(city), .office(office)]

        static let peterburgCity = City(uid: "2", name: "Peterburg", path: "peterburg")
        static let kazanCity = City(uid: "3", name: "Kazan", path: "kazan")
        static let rostovCity = City(uid: "4", name: "Rostov", path: "rostov")
        static let unsortedCities = [rostovCity, city, kazanCity, peterburgCity]
        static let sortedCities = [city, peterburgCity, kazanCity, rostovCity]
        static let cardID = "123"
        static let errorString = "custom error"
    }
}

private class OfficeChangingProviderMock: ProvidesBankOffices {
    var getCitiesWasCalled = 0
    var getCitiesStub: Promise<[City]> = Promise(error: ServiceError.other)
    var getMetroWasCalled = 0
    var getMetroArguments: City?
    var getMetroStub: Promise<[Metro]> = Promise(error: ServiceError.other)
    var getOfficesWasCalled = 0
    var getOfficesArguments: (city: City?, metro: Metro?) = (nil, nil)
    var getOfficesStub: Promise<[Office]> = Promise(error: ServiceError.other)
    var invalidateCacheWasCalled = 0
    var invalidateOfficesCacheWasCalled = 0

    func getCities() -> Promise<[City]> {
        getCitiesWasCalled += 1
        return getCitiesStub
    }

    func getMetro(in city: City) -> Promise<[Metro]> {
        getMetroWasCalled += 1
        getMetroArguments = city
        return getMetroStub
    }

    func getOffice(in city: City, nearBy metro: Metro?) -> Promise<[Office]> {
        getOfficesWasCalled += 1
        getOfficesArguments = (city: city, metro: metro)
        return getOfficesStub
    }

    func invalidateCache() {
        invalidateCacheWasCalled += 1
    }

    func invalidateOfficesCache() {
        invalidateOfficesCacheWasCalled += 1
    }
}

private class OfficeChangingPresenterMock: OfficeChangingPresentationLogic {
    var presentCellsWasCalled = 0
    var presentCellsResponse: OfficeChanging.PresentCells.Response?
    var presentErrorWasCalled = 0
    var presentErrorArgument: OfficeChanging.ErrorType?
    var presentCitiesListWasCalled = 0
    var presentCitiesListArguments: OfficeChanging.OpenCitiesList.Response?
    var presentMetroListWasCalled = 0
    var presentMetroListArguments: OfficeChanging.OpenMetroList.Response?
    var presentOfficesListWasCalled = 0
    var presentOfficesListArguments: OfficeChanging.OpenOfficesList.Response?
    var presentUpdatedReissuesOfficeWasCalled = 0

    func present(_ response: OfficeChanging.PresentCells.Response) {
        presentCellsWasCalled += 1
        presentCellsResponse = response
    }

    func presentError(_ error: OfficeChanging.ErrorType) {
        presentErrorWasCalled += 1
        presentErrorArgument = error
    }

    func presentCitiesList(_ response: OfficeChanging.OpenCitiesList.Response) {
        presentCitiesListWasCalled += 1
        presentCitiesListArguments = response
    }

    func presentMetroList(_ response: OfficeChanging.OpenMetroList.Response) {
        presentMetroListWasCalled += 1
        presentMetroListArguments = response
    }

    func presentOfficesList(_ response: OfficeChanging.OpenOfficesList.Response) {
        presentOfficesListWasCalled += 1
        presentOfficesListArguments = response
    }

    func presentUpdatedReissuesOffice() {
        presentUpdatedReissuesOfficeWasCalled += 1
    }
}

private class OfficeChangingUpdateServiceMock: UpdatesReissuesOffice {
    var updateReissuesOfficeWasCalled = 0
    var updateReissuesOfficeArguments: (String, String)?
    var updateReissuesOfficeStub: RResult<Any, ServiceError> = .failure(.other)
    func updateReissuesOffice(
        cardID: String,
        officeID: String,
        completion: @escaping (RResult<Any, ServiceError>) -> Void
    ) {
        updateReissuesOfficeWasCalled += 1
        updateReissuesOfficeArguments = (cardID, officeID)
        completion(updateReissuesOfficeStub)
    }
}
