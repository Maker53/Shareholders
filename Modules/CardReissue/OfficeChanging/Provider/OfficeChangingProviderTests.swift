//
//  SUT: OfficeChangingProvider
//
//  Collaborators:
//  CityService
//  MetroService
//  OfficeService

import AlfaNetworking
import NetworkKit
import SharedServices
import TestAdditions

@testable import CardReissue

final class OfficeChangingProviderTests: QuickSpec {
    override func spec() {
        var provider: OfficeChangingProvider!
        var cityServiceMock: DefaultNetworkServiceMock<[City], Void, Void>!
        var metroServiceMock: DefaultNetworkServiceMock<[Metro], MetroServiceParameters, Void>!
        var officeServiceMock: DefaultNetworkServiceMock<[Office], OfficeServiceParameters, Void>!
        var dataStoreMock: OfficeChangingDataStoreMock!

        beforeEach {
            cityServiceMock = DefaultNetworkServiceMock()
            metroServiceMock = DefaultNetworkServiceMock()
            officeServiceMock = DefaultNetworkServiceMock()
            dataStoreMock = OfficeChangingDataStoreMock()
            provider = OfficeChangingProvider(
                cityService: cityServiceMock,
                metroService: metroServiceMock,
                officeService: officeServiceMock,
                dataStore: dataStoreMock
            )
        }

        describe(".getCities") {
            it("should return models from data store") {
                // given
                dataStoreMock.cities = TestData.citiesStub
                var result: [City] = []
                // when
                firstly {
                    provider.getCities()
                }.done {
                    result = $0
                }.cauterize()
                // then
                expect(result).toEventually(equal(TestData.citiesStub))
            }

            it("should return models from service") {
                // given
                dataStoreMock.cities = []
                var result: [City] = []
                cityServiceMock.sendRequestCompletionStub = .success(TestData.citiesStub)
                // when
                firstly {
                    provider.getCities()
                }.done {
                    result = $0
                }.cauterize()
                // then
                expect(result).toEventually(equal(TestData.citiesStub))
            }

            it("should return error from service") {
                // given
                dataStoreMock.cities = []
                var result: [City] = []
                cityServiceMock.sendRequestCompletionStub = .failure(.other)
                // when
                firstly {
                    provider.getCities()
                }.done {
                    result = $0
                }.cauterize()
                // then
                expect(result).toEventually(beEmpty())
            }
        }

        describe(".getMetro") {
            it("should return models from data store") {
                // given
                dataStoreMock.metro = TestData.metroStub
                var result: [Metro] = []
                // when
                firstly {
                    provider.getMetro(in: TestData.city)
                }.done {
                    result = $0
                }.cauterize()
                // then
                expect(metroServiceMock.sendRequestWasCalled).toNot(beCalled())
                expect(result).toEventually(equal(TestData.metroStub))
            }

            it("should return models from service") {
                // given
                dataStoreMock.metro = []
                var result: [Metro] = []
                metroServiceMock.sendRequestCompletionStub = .success(TestData.metroStub)
                // when
                firstly {
                    provider.getMetro(in: TestData.city)
                }.done {
                    result = $0
                }.cauterize()
                // then
                expect(metroServiceMock.sendRequestWasCalled).to(beCalledOnce())
                expect(metroServiceMock.sendRequestReceivedArguments?.parameters.uid).toEventually(equal(TestData.city.uid))
                expect(result).toEventually(equal(TestData.metroStub))
            }

            it("should return error from service") {
                // given
                dataStoreMock.metro = []
                var result: [Metro] = []
                metroServiceMock.sendRequestCompletionStub = .failure(.other)
                // when
                firstly {
                    provider.getMetro(in: TestData.city)
                }.done {
                    result = $0
                }.cauterize()
                // then
                expect(result).toEventually(beEmpty())
            }
        }

        describe(".getOffices") {
            it("should return models from data store") {
                // given
                dataStoreMock.offices = TestData.officesStub
                var result: [Office] = []
                // when
                firstly {
                    provider.getOffice(in: TestData.city, nearBy: TestData.metro)
                }.done {
                    result = $0
                }.cauterize()
                // then
                expect(officeServiceMock.sendRequestWasCalled).toNot(beCalled())
                expect(result).toEventually(equal(TestData.officesStub))
            }

            it("should return models from service") {
                // given
                dataStoreMock.offices = []
                var result: [Office] = []
                officeServiceMock.sendRequestCompletionStub = .success(TestData.officesStub)
                // when
                firstly {
                    provider.getOffice(in: TestData.city, nearBy: TestData.metro)
                }.done {
                    result = $0
                }.cauterize()
                // then
                expect(officeServiceMock.sendRequestWasCalled).to(beCalledOnce())
                expect(officeServiceMock.sendRequestReceivedArguments?.parameters.city).toEventually(equal(TestData.city.uid))
                expect(officeServiceMock.sendRequestReceivedArguments?.parameters.metro).toEventually(equal(TestData.metro.uid))
                expect(result).toEventually(equal(TestData.officesStub))
            }

            it("should return error from service") {
                // given
                dataStoreMock.offices = []
                var result: [Office] = []
                officeServiceMock.sendRequestCompletionStub = .failure(.other)
                // when
                firstly {
                    provider.getOffice(in: TestData.city, nearBy: TestData.metro)
                }.done {
                    result = $0
                }.cauterize()
                // then
                expect(result).toEventually(beEmpty())
            }
        }

        describe(".invalidateCache") {
            it("should purge cache") {
                // given
                dataStoreMock.cities = TestData.citiesStub
                dataStoreMock.metro = TestData.metroStub
                dataStoreMock.offices = TestData.officesStub
                // when
                provider.invalidateCache()
                // then
                expect(dataStoreMock.cities).to(equal(TestData.citiesStub))
                expect(dataStoreMock.metro).to(beEmpty())
                expect(dataStoreMock.offices).to(beEmpty())
            }
        }
        describe(".invalidateOfficesCache") {
            it("should invalidate offices cache") {
                // given
                dataStoreMock.offices = TestData.officesStub
                // when
                provider.invalidateOfficesCache()
                // then
                expect(dataStoreMock.offices).to(beEmpty())
            }
        }
    }
}

private extension OfficeChangingProviderTests {
    enum TestData {
        static let city = City.Seeds.defaultModel
        static let metro = Metro.Seeds.defaultModel
        static let citiesStub = [City.Seeds.defaultModel, City.Seeds.defaultModel]
        static let metroStub = [Metro.Seeds.defaultModel, Metro.Seeds.defaultModel]
        static let officesStub = [Office.Seeds.defaultModel, Office.Seeds.defaultModel]
    }
}

private final class OfficeChangingDataStoreMock: OfficeChangingDataStore { }
