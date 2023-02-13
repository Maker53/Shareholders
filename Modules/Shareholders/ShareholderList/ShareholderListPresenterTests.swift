// Created by Станислав on 07.02.2023.

import TestAdditions
@testable import Shareholders

final class ShareholderListPresenterTests: QuickSpec {
    override func spec() {
        var viewControllerMock: ShareholderListDisplayLogicMock!
        var preseneter: ShareholderListPresenter!
        
        beforeEach {
            viewControllerMock = .init()
            preseneter = .init()
            preseneter.viewController = viewControllerMock
        }
        
        describe(".presentShareholderList") {
            it("should call view controller for display shareholder list") {
                // when
                preseneter.presentShareholderList(TestData.PresentShareholderList.response)
                // then
                expect(viewControllerMock.displayShareholedListWasCalled).to(beCalledOnce())
                expect(viewControllerMock.displayShareholedListReceivedViewModel).to(equal(TestData.PresentShareholderList.viewModel))
            }
        }
    }
}

// MARK: - TestData

private extension ShareholderListPresenterTests {
    enum TestData {
        enum PresentShareholderList {
            static let response = ShareholderListDataFlow.PresentShareholderList.Response()
            static let viewModel = ShareholderListDataFlow.PresentShareholderList.ViewModel()
        }
    }
}
