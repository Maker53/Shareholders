// Created by Станислав on 07.02.2023.

import TestAdditions
@testable import Shareholders

final class ShareholderListInteractorTests: QuickSpec {
    override func spec() {
        var presenterMock: ShareholderListPresentationLogicMock!
        var interactor: ShareholderListInteractor!
        
        beforeEach {
            presenterMock = .init()
            interactor = .init(presenter: presenterMock)
        }
        
        describe(".fetchShareholderList") {
            it("should call presenter for present shareholder list") {
                // when
                interactor.fetchShareholderList(TestData.PresentShareholderList.request)
                // then
                expect(presenterMock.presentShareholderListWasCalled).to(beCalledOnce())
                expect(presenterMock.presentShareholderListReceivedResponse).to(equal(TestData.PresentShareholderList.response))
            }
        }
    }
}

// MARK: - TestData

private extension ShareholderListInteractorTests {
    enum TestData {        
        enum PresentShareholderList {
            static let request = ShareholderListDataFlow.PresentShareholderList.Request()
            static let response = ShareholderListDataFlow.PresentShareholderList.Response()
        }
    }
}
