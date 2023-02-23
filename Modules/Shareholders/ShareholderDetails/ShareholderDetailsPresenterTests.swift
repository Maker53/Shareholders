// Created by Станислав on 16.02.2023.

import TestAdditions
@testable import Shareholders

final class ShareholderDetailsPresenterTests: QuickSpec {
    override func spec() {
        var viewControllerMock: ShareholderDetailsDisplayLogicMock!
        var presenter: ShareholderDetailsPresenter!
        
        beforeEach {
            viewControllerMock = .init()
            presenter = .init()
            presenter.viewController = viewControllerMock
        }
        
        describe(".presentShareholderDetails") {
            it("should call view controller for dislpay shareholder details") {
                // when
                presenter.presentShareholderDetails(TestData.PresentShareholderDetails.response)
                // then
                expect(viewControllerMock.displayShareholderDetailsWasCalled).to(beCalledOnce())
                expect(viewControllerMock.displayShareholderDetailsReceivedViewModel)
                    .to(equal(TestData.PresentShareholderDetails.viewModel))
            }
        }
    }
}

// MARK: - TestData

private extension ShareholderDetailsPresenterTests {
    enum TestData {
        enum PresentShareholderDetails {
            static let shareholder = Shareholder.Seeds.value
            static let shareholderCellViewModel = ShareholderCellViewModel.Seeds.value
            static let response = ShareholderDetailsDataFlow.PresentShareholderDetails.Response(
                shareholderDetails: shareholder
            )
            static let viewModel = ShareholderDetailsDataFlow.PresentShareholderDetails.ViewModel(
                shareholderDetails: shareholderCellViewModel
            )
        }
    }
}
