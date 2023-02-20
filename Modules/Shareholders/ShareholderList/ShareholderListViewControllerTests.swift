// Created by Станислав on 07.02.2023.

import TestAdditions
import ABUIComponents
@testable import Shareholders

final class ShareholderListViewControllerTests: QuickSpec {
    override func spec() {
        var interactorMock: ShareholderListBusinessLogicMock!
        var contentViewMock: DisplayShareholderListViewMock!
        let routesMock = ShareholderListRoutesMock.self
        var viewController: ShareholderListViewController<ShareholderListRoutesMock>!
        
        beforeEach {
            interactorMock = .init()
            contentViewMock = .init()
            viewController = .init(interactor: interactorMock)
        }
        
        describe(".loadView") {
            it("should setup view") {
                // when
                viewController.contentView = contentViewMock
                // then
                expect(viewController.view).to(beIdenticalTo(contentViewMock))
                expect(viewController.view.backgroundColor).to(equal(TestData.contentViewBackgroundColor))
            }
            
            it("should set view delegate") {
                // when
                let contentView = viewController.contentView as? ShareholderListView
                // then
                expect(contentView?.delegate).to(beIdenticalTo(viewController))
            }
        }
        
        describe(".viewDidLoad") {
            it("should call interactor for fetch shareholder list") {
                // when
                viewController.loadViewIfNeeded()
                // then
                expect(interactorMock.fetchShareholderListWasCalled).to(beCalledOnce())
            }
        }
        
        describe(".displayShareholedList") {
            it("should configure view") {
                // given
                viewController.contentView = contentViewMock
                // when
                viewController.displayShareholedList(TestData.PresentShareholderList.viewModel)
                // then
                expect(contentViewMock.configureWasCalled).to(beCalledOnce())
                expect(contentViewMock.configureReceivedViewModel).to(equal(TestData.PresentShareholderList.viewModel))
            }
        }
        
        describe(".displayShareholderDetails") {
            it("should navigate to shareholder details") {
                // when
                viewController.displayShareholderDetails(TestData.PresentShareholderDetails.viewModel)
                // then
                expect(routesMock.shareholderDetailsWasCalled).to(beCalledOnce())
                expect(routesMock.shareholderDetailsReceivedUid).to(equal(TestData.PresentShareholderDetails.uid))
            }
        }
        
        describe(".didSelectShareholder") {
            it("should call interactor for open shareholder details") {
                // when
                viewController.didSelectShareholder(TestData.PresentShareholderDetails.uid)
                // then
                expect(interactorMock.openShareholderDetailsWasCalled).to(beCalledOnce())
                expect(interactorMock.openShareholderDetailsReceivedRequest)
                    .to(equal(TestData.PresentShareholderDetails.request))
            }
        }
    }
}

// MARK: - TestData

private extension ShareholderListViewControllerTests {
    enum TestData: Theme {
        static let contentViewBackgroundColor = Palette.backgroundPrimary
        static let cellViewModel = ShareholderListCellViewModel.Seeds.value
        static let unknownCompanyCellViewModel = ShareholderListCellViewModel.Seeds.valueCompanyUnknown
        
        enum PresentShareholderList {
            static let shareholderListCellViewModels = [
                cellViewModel,
                unknownCompanyCellViewModel
            ]
            static let viewModel = ShareholderListDataFlow.PresentShareholderList.ViewModel(
                rows: shareholderListCellViewModels
            )
        }
        
        enum PresentShareholderDetails {
            static let uid = cellViewModel.uid
            static let viewModel = ShareholderListDataFlow.PresentShareholderDetails.ViewModel(uid: uid)
            static let request = ShareholderListDataFlow.PresentShareholderDetails.Request(
                uid: uid
            )
        }
    }
}
