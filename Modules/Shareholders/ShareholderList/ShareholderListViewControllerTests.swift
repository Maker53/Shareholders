// Created by Станислав on 07.02.2023.

import TestAdditions
import ABUIComponents
@testable import Shareholders

final class ShareholderListViewControllerTests: QuickSpec {
    override func spec() {
        var interactorMock: ShareholderListBusinessLogicMock!
        var contentViewMock: DisplayShareholderListViewMock!
        var contentView: ShareholderListView!
        var viewController: ShareholderListViewController<ShareholderListRoutesMock>!
        
        beforeEach {
            interactorMock = .init()
            contentViewMock = .init()
            viewController = .init(interactor: interactorMock)
            contentView = .init(delegate: viewController)
            viewController.contentView = contentView
        }
        
        describe(".loadView") {
            it("should setup view") {
                // when
                viewController.contentView = contentViewMock
                viewController.loadView()
                // then
                expect(viewController.view).to(beIdenticalTo(contentViewMock))
                expect(viewController.view.backgroundColor).to(equal(TestData.contentViewBackgroundColor))
            }
            
            it("should set view delegate") {
                // when
                viewController.loadView()
                // then
                expect(contentView.delegate).to(beIdenticalTo(viewController))
            }
        }
        
        describe(".viewDidLoad") {
            it("should call interactor for fetch shareholder list") {
                // when
                interactorMock.fetchShareholderList(TestData.PresentShareholderList.request)
                // then
                expect(interactorMock.fetchShareholderListWasCalled).to(beCalledOnce())
                expect(interactorMock.fetchShareholderListReceivedRequest).to(equal(TestData.PresentShareholderList.request))
            }
        }
    }
}

// MARK: - TestData

private extension ShareholderListViewControllerTests {
    enum TestData: Theme {
        static let contentViewBackgroundColor = Palette.backgroundPrimary
        
        enum PresentShareholderList {
            static let request = ShareholderListDataFlow.PresentShareholderList.Request()
            static let viewModel = ShareholderListDataFlow.PresentShareholderList.ViewModel()
        }
    }
}
