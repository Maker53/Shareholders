// Created by Станислав on 08.02.2023.

import TestAdditions
import AlfaNetworking
import NetworkKit
@testable import Shareholders

final class ShareholderListProviderTests: QuickSpec {
    override func spec() {
        var networkServiceMock: NetworkServiceMock<ShareholderList, Void, Void, ServiceError>!
        var provider: ShareholderListProvider!
        
        beforeEach {
            networkServiceMock = .init()
            provider = .init(service: networkServiceMock)
        }
        
        describe(".fetchShareholderList") {
            it("should call network service") {
                // when
                _ = provider.fetchShareholderList()
                // then
                expect(networkServiceMock.sendRequestWasCalled).toEventually(beCalledOnce())
            }
            
            context("when successful response") {
                it("should return response model") {
                    // given
                    networkServiceMock.sendRequestCompletionStub = .success(TestData.responseModel)
                    // when
                    let result = provider.fetchShareholderList()
                    // then
                    expect(result.value).toEventually(equal(TestData.responseModel))
                }
            }
            
            context("when failure response") {
                it("should return error") {
                    // given
                    networkServiceMock.sendRequestCompletionStub = .failure(TestData.responseError)
                    // when
                    let result = provider.fetchShareholderList()
                    // then
                    expect(result.error).toEventually(matchError(TestData.responseError))
                }
            }
        }
    }
}

// MARK: - TestData

private extension ShareholderListProviderTests {
    enum TestData {
        static let responseModel = ShareholderList.Seeds.values
        static let responseError: ServiceError = .other
    }
}
