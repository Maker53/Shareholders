// Created by Станислав on 16.02.2023.

import SharedProtocolsAndModels
import TestAdditions
@testable import Shareholders

final class ShareholderDetailsPresenterTests: QuickSpec {
    override func spec() {
        var viewControllerMock: ShareholderDetailsDisplayLogicMock!
        var featuresServiceMock: FeaturesServiceMock!
        var presenter: ShareholderDetailsPresenter!
        
        beforeEach {
            viewControllerMock = .init()
            featuresServiceMock = .init()
            presenter = .init(featureService: featuresServiceMock)
            presenter.viewController = viewControllerMock
        }
        
        describe(".presentShareholderDetails") {
            context("when FT enabled") {
                it("should call view controller with shareholder and company names swapped") {
                    // given
                    featuresServiceMock.anySpecifiedEnabledFeatures = [
                        .extra(ShareholdersFeature.swapShareholderAndCompanyName.rawValue)
                    ]
                    // when
                    presenter.presentShareholderDetails(TestData.PresentShareholderDetails.response)
                    // then
                    expect(viewControllerMock.displayShareholderDetailsWasCalled).to(beCalledOnce())
                    expect(viewControllerMock.displayShareholderDetailsReceivedViewModel)
                        .to(equal(TestData.PresentShareholderDetails.swappedViewModel))
                }
            }
            
            context("when FT disabled") {
                it("should call view controller for display shareholder details") {
                    // given
                    featuresServiceMock.anySpecifiedEnabledFeatures = []
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
}

// MARK: - TestData

private extension ShareholderDetailsPresenterTests {
    enum TestData {
        enum PresentShareholderDetails {
            static let shareholder = Shareholder.Seeds.value
            static let shareholderCellViewModel = ShareholderCellViewModel.Seeds.value
            static let swappedShareholderCellViewModel = ShareholderCellViewModel.Seeds.swappedValue
            static let response = ShareholderDetailsDataFlow.PresentShareholderDetails.Response(
                shareholderDetails: shareholder
            )
            static let viewModel = ShareholderDetailsDataFlow.PresentShareholderDetails.ViewModel(
                shareholderDetails: shareholderCellViewModel
            )
            static let swappedViewModel = ShareholderDetailsDataFlow.PresentShareholderDetails.ViewModel(
                shareholderDetails: swappedShareholderCellViewModel
            )
        }
    }
}
