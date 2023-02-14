// Created by Станислав on 08.02.2023.

import TestAdditions
import AlfaNetworking
import NetworkKit
@testable import Shareholders

final class ShareholderListProviderTests: QuickSpec {
    override func spec() {
        var networkServiceMock: NetworkServiceMock<ShareholderList, Void, Void, ServiceError>!
        var dataStoreMock: StoresShareholderListMock!
        var provider: ShareholderListProvider!
        
        beforeEach {
            networkServiceMock = .init()
            dataStoreMock = .init()
            provider = .init(dataStore: dataStoreMock, service: networkServiceMock)
        }
        
        describe(".fetchShareholderList") {
            context("when usingCache is true") {
                context("when dataStore contains model") {
                    it("should return response model from DataStore") {
                        // given
                        dataStoreMock.shareholderListModelStub = TestData.model
                        // when
                        let result = provider.fetchShareholderList()
                        // then
                        expect(dataStoreMock.getShareholderListModelWasCalled).to(beCalledOnce())
                        expect(networkServiceMock.sendRequestWasCalled).toNot(beCalled())
                        expect(result.value).to(equal(TestData.model))
                    }
                }
                
                context("when dataStore doesn't contain model") {
                    it("should call networkService") {
                        // given
                        dataStoreMock.shareholderListModelStub = nil
                        // when
                        _ = provider.fetchShareholderList()
                        // then
                        expect(dataStoreMock.getShareholderListModelWasCalled).to(beCalledOnce())
                        expect(networkServiceMock.sendRequestWasCalled).to(beCalledOnce())
                    }
                }
            }
            
            context("when usingCache is false") {
                context("when successful response from networkService call") {
                    it("return response model") {
                        // given
                        networkServiceMock.sendRequestCompletionStub = .success(TestData.model)
                        // when
                        let result = provider.fetchShareholderList()
                        // then
                        expect(dataStoreMock.setShareholderListModelWasCalled).toEventually(beCalledOnce())
                        expect(result.value).toEventually(equal(TestData.model))
                    }
                }
                
                context("when failure response from networkService call") {
                    it("should return error") {
                        // given
                        networkServiceMock.sendRequestCompletionStub = .failure(TestData.error)
                        // when
                        let result = provider.fetchShareholderList()
                        // then
                        expect(dataStoreMock.setShareholderListModelWasCalled).toNotEventually(beCalledOnce())
                        expect(result.error).toEventually(matchError(TestData.error))
                    }
                }
            }
        }
    }
}

// MARK: - TestData

private extension ShareholderListProviderTests {
    enum TestData {
        static let model = ShareholderList.Seeds.values
        static let error: ServiceError = .other
    }
}
