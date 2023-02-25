// Created by Станислав on 16.02.2023.

import TestAdditions
import SharedPromiseKit
import AlfaNetworking
@testable import Shareholders

final class ShareholderDetailsInteractorTests: QuickSpec {
    override func spec() {
        var presenterMock: ShareholderDetailsPresentationLogicMock!
        var providerMock: ProvidesShareholderDetailsMock!
        var interactor: ShareholderDetailsInteractor!
        
        beforeEach {
            presenterMock = .init()
            providerMock = .init()
            interactor = .init(presenter: presenterMock, provider: providerMock)
        }
        
        describe(".fetchShareholderDetails") {
            context("when received shareholder details") {
                it("should call presenter for present shareholder details") {
                    // given
                    providerMock.fetchShareholderDetailsStub = TestData.PresentShareholderDetails.providerSuccessResponse
                    // when
                    interactor.fetchShareholderDetails(TestData.PresentShareholderDetails.request)
                    // then
                    expect(providerMock.fetchShareholderDetailsWasCalled).to(beCalledOnce())
                    expect(providerMock.fetchShareholderDetailsReceivedId)
                        .to(equal(TestData.PresentShareholderDetails.id))
                    expect(presenterMock.presentShareholderDetailsWasCalled).toEventually(beCalledOnce())
                    expect(presenterMock.presentShareholderDetailsReceivedResponse)
                        .toEventually(equal(TestData.PresentShareholderDetails.response))
                }
            }
            
            context("when received error") {
                it("shouldn't call presenter") {
                    // given
                    providerMock.fetchShareholderDetailsStub = TestData.PresentShareholderDetails.providerErrorResponse
                    // when
                    interactor.fetchShareholderDetails(TestData.PresentShareholderDetails.request)
                    // then
                    expect(providerMock.fetchShareholderDetailsWasCalled).to(beCalledOnce())
                    expect(providerMock.fetchShareholderDetailsReceivedId)
                        .to(equal(TestData.PresentShareholderDetails.id))
                    expect(presenterMock.presentShareholderDetailsWasCalled).toNotEventually(beCalledOnce())
                }
            }
        }
    }
}

// MARK: - TestData

private extension ShareholderDetailsInteractorTests {
    enum TestData {
        enum PresentShareholderDetails {
            static let request = ShareholderDetailsDataFlow.PresentShareholderDetails.Request(
                uid: id
            )
            static let response = ShareholderDetailsDataFlow.PresentShareholderDetails.Response(
                shareholderDetails: value
            )
            static let value = Shareholder.Seeds.value
            static let id = value.id
            static let error = ServiceError.other
            static let providerSuccessResponse = Promise.value(value)
            static let providerErrorResponse: Promise<Shareholder> = .init(error: error)
        }
    }
}
