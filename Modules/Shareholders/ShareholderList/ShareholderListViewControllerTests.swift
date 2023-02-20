// Created by Станислав on 07.02.2023.

import TestAdditions
import ABUIComponents
@testable import Shareholders

final class ShareholderListViewControllerTests: QuickSpec {
    override func spec() {
        var interactorMock: ShareholderListBusinessLogicMock!
        var contentViewMock: DisplayShareholderListViewMock!
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
            
            it("should set view delegate and tableManager") {
                // when
                let contentView = viewController.contentView as? ShareholderListView
                // then
                expect(contentView?.delegate).to(beIdenticalTo(viewController))
                expect(contentView?.tableManager).to(beAnInstanceOf(TestData.tableManagerType))
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
    }
}

// MARK: - TestData

private extension ShareholderListViewControllerTests {
    enum TestData: Theme {
        static let contentViewBackgroundColor = Palette.backgroundPrimary
        static let tableManagerType = ShareholderListTableManager.self
        
        enum PresentShareholderList {
            static let shareholderListCellViewModels = [
                ShareholderListCellViewModel.Seeds.value,
                ShareholderListCellViewModel.Seeds.valueCompanyUnknown
            ]
            static let viewModel = ShareholderListDataFlow.PresentShareholderList.ViewModel(rows: shareholderListCellViewModels)
        }
    }
}
