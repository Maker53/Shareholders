// Created by Станислав on 16.02.2023.

import TestAdditions
import ABUIComponents
@testable import Shareholders

final class ShareholderDetailsViewControllerTests: QuickSpec {
    override func spec() {
        var interactorMock: ShareholderDetailsBusinessLogicMock!
        var contentViewMock: DisplaysShareholderDetailsViewMock!
        var viewController: ShareholderDetailsViewController<ShareholderDetailsRoutesMock>!
        
        beforeEach {
            interactorMock = .init()
            contentViewMock = .init()
            viewController = .init(interactor: interactorMock, uid: TestData.PresentShareholderDetails.uid)
        }
        
        describe(".loadView") {
            it("should setup view") {
                // when
                viewController.contentView = contentViewMock
                // then
                expect(viewController.view).to(beIdenticalTo(contentViewMock))
                expect(viewController.view.backgroundColor).to(equal(TestData.contentViewBackgroundColor))
            }
        }
        
        describe(".viewDidLoad") {
            it("should call interactor for fetch shareholder details") {
                // when
                viewController.loadViewIfNeeded()
                // then
                expect(interactorMock.fetchShareholderDetailsWasCalled).to(beCalledOnce())
                expect(interactorMock.fetchShareholderDetailsReceivedRequest)
                    .to(equal(TestData.PresentShareholderDetails.request))
            }
        }
        
        describe(".displayShareholderDetails") {
            it("should configure view") {
                // when
                viewController.contentView = contentViewMock
                viewController.displayShareholderDetails(TestData.PresentShareholderDetails.viewModel)
                // then
                expect(contentViewMock.configureWasCalled).to(beCalledOnce())
                expect(contentViewMock.configureReceivedRequest)
                    .to(equal(TestData.PresentShareholderDetails.viewModel))
            }
        }
    }
}

// MARK: - TestData

private extension ShareholderDetailsViewControllerTests {
    enum TestData {
        static let contentViewBackgroundColor = appearance.palette.backgroundPrimary
        static let appearance = Appearance(); struct Appearance: Theme { }
        
        enum PresentShareholderDetails {
            static let uid = Shareholder.Seeds.value.id
            static let cellViewModel = ShareholderCellViewModel.Seeds.value
            static let request = ShareholderDetailsDataFlow.PresentShareholderDetails.Request(uid: uid)
            static let viewModel = ShareholderDetailsDataFlow.PresentShareholderDetails.ViewModel(
                shareholderDetails: cellViewModel
            )
        }
    }
}
