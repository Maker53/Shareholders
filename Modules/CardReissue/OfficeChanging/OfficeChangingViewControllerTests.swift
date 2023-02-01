//
//  SUT: OfficeChangingViewController
//
//  Collaborators:
//  OfficeChangingInteractor

import ABUIComponents
import AlfaFoundation
import TestAdditions

@testable import CardReissue

final class OfficeChangingViewControllerTests: QuickSpec {
    override func spec() {
        var viewController: OfficeChangingViewController!
        var interactorMock: OfficeChangingInteractorMock!
        var routesMock: OfficeChangingRoutesMock.Type!

        beforeEach {
            routesMock = OfficeChangingRoutesMock.self
            interactorMock = OfficeChangingInteractorMock()
            viewController = OfficeChangingViewController(
                interactor: interactorMock,
                routes: routesMock,
                delegateBlock: nil
            )
        }

        describe(".viewDidLoad") {
            it("should call interactor") {
                // when
                viewController.loadViewIfNeeded()
                // then
                expect(interactorMock.getCitiesWasCalled).to(beCalledOnce())
            }
        }

        describe(".didSelectRow") {
            it("should call interactor to get cities") {
                // when
                viewController.didSelectRow(.city)
                // then
                expect(interactorMock.openCitiesListWasCalled).to(beCalledOnce())
            }

            it("should call interactor to get metro") {
                // when
                viewController.didSelectRow(.metro)
                // then
                expect(interactorMock.openMetroListWasCalled).to(beCalledOnce())
            }

            it("should call interactor to get offices") {
                // when
                viewController.didSelectRow(.office)
                // then
                expect(interactorMock.openOfficesListWasCalled).to(beCalledOnce())
            }
        }

        describe(".didTapUpdateButton") {
            it("should call interactor to get cities") {
                // when
                viewController.didTapUpdateButton()
                // then
                expect(interactorMock.getCitiesWasCalled).to(beCalledOnce())
            }
        }

        describe(".didTapOnConfirmationButton") {
            it("should call interactor") {
                // when
                viewController.didTapOnConfirmationButton()
                // then
                expect(interactorMock.updateReissuesOfficeWasCalled).to(beCalledOnce())
            }
        }

        describe(".displayUpdatedReissuesOffice") {
            it("should navigate back") {
                // when
                viewController.displayUpdatedReissuesOffice()
                // then
                expect(routesMock.backWasCalled).to(beCalledOnce())
            }
        }

        describe(".displayError") {
            it("should navigate to alert controller") {
                // when
                viewController.displayError(.defaultError)
                // then
                expect(routesMock.alertWasCalled).to(beCalledOnce())
            }
        }
    }
}

private class OfficeChangingInteractorMock: OfficeChangingBusinessLogic {
    var getCitiesWasCalled = 0
    var openCitiesListWasCalled = 0
    var selectCityWasCalled = 0
    var selectCityArguments: OfficeChanging.SelectCity.Request?
    var openMetroListWasCalled = 0
    var selectMetroWasCalled = 0
    var selectMetroArguments: OfficeChanging.SelectMetro.Request?
    var selectOfficeWasCalled = 0
    var selectOfficeArguments: OfficeChanging.SelectOffice.Request?
    var openOfficesListWasCalled = 0
    var updateReissuesOfficeWasCalled = 0

    func getCities() {
        getCitiesWasCalled += 1
    }

    func openCitiesList() {
        openCitiesListWasCalled += 1
    }

    func selectCity(_ request: OfficeChanging.SelectCity.Request) {
        selectCityWasCalled += 1
        selectCityArguments = request
    }

    func openMetroList() {
        openMetroListWasCalled += 1
    }

    func selectMetro(_ request: OfficeChanging.SelectMetro.Request) {
        selectMetroWasCalled += 1
        selectMetroArguments = request
    }

    func selectOffice(_ request: OfficeChanging.SelectOffice.Request) {
        selectOfficeWasCalled += 1
        selectOfficeArguments = request
    }

    func openOfficesList() {
        openOfficesListWasCalled += 1
    }

    func updateReissuesOffice() {
        updateReissuesOfficeWasCalled += 1
    }
}
