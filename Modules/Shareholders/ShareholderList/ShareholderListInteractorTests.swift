// Created by Станислав on 07.02.2023.

import TestAdditions
import AlfaNetworking
@testable import Shareholders

final class ShareholderListInteractorTests: QuickSpec {
    override func spec() {
        var presenterMock: ShareholderListPresentationLogicMock!
        var providerMock: ProvidesShareholderListMock!
        var interactor: ShareholderListInteractor!
        
        beforeEach {
            presenterMock = .init()
            providerMock = .init()
            interactor = .init(presenter: presenterMock, provider: providerMock)
        }
        
        describe(".fetchShareholderList") {
            context("when received shareholder list") {
                it("should call presenter for present shareholder list") {
                    // given
                    providerMock.fetchShareholderListStub = TestData.PresentShareholderList.providerSuccessResponse
                    // when
                    interactor.fetchShareholderList()
                    // then
                    expect(providerMock.fetchShareholderListWasCalled).to(beCalledOnce())
                    expect(providerMock.fetchShareholderListWasCalledReceivedUsingCache).to(equal(true))
                    expect(presenterMock.presentShareholderListWasCalled).toEventually(beCalledOnce())
                    expect(presenterMock.presentShareholderListReceivedResponse)
                        .toEventually(equal(TestData.PresentShareholderList.response))
                }
            }
            
            context("when received error") {
                it("shouldn't call presenter") {
                    // given
                    providerMock.fetchShareholderListStub = TestData.PresentShareholderList.providerErrorResponse
                    // when
                    interactor.fetchShareholderList()
                    // then
                    expect(providerMock.fetchShareholderListWasCalled).to(beCalledOnce())
                    expect(providerMock.fetchShareholderListWasCalledReceivedUsingCache).to(equal(true))
                    expect(presenterMock.presentShareholderListWasCalled).toNotEventually(beCalledOnce())
                }
            }
        }
    }
}

// MARK: - TestData

private extension ShareholderListInteractorTests {
    enum TestData {        
        enum PresentShareholderList {
            static let value = ShareholderList.Seeds.values
            static let providerSuccessResponse = Promise.value(value)
            static let providerErrorResponse: Promise<ShareholderList> = .init(error: error)
            static let error = ServiceError.other
            static let response = ShareholderListDataFlow.PresentShareholderList.Response(
                shareholders: value
            )
        }
    }
}
