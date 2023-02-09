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
                it("should try to use cache") {
                    // given
                    dataStoreMock.shareholderListModelStub = TestData.model
                    // when
                    _ = provider.fetchShareholderList(usingCache: true)
                    // then
                    expect(dataStoreMock.getShareholderListModelWasCalled).to(beCalledOnce())
                    expect(dataStoreMock.shareholderListModel).to(equal(TestData.model))
                    expect(networkServiceMock.sendRequestWasCalled).toNot(beCalled())
                }
            }
            
            context("when usingCache is false") {
                it("should not try to use cache") {
                    // when
                    _ = provider.fetchShareholderList(usingCache: false)
                    // then
                    expect(dataStoreMock.getShareholderListModelWasCalled).toNot(beCalled())
                    expect(networkServiceMock.sendRequestWasCalled).toEventually(beCalledOnce())
                }
            }
            
            context("when DataStore contains response model") {
                it("should return response model from DataStore") {
                    // given
                    dataStoreMock.shareholderListModelStub = TestData.model
                    // when
                    _ = provider.fetchShareholderList()
                    // then
                    expect(dataStoreMock.shareholderListModel).to(equal(TestData.model))
                    expect(networkServiceMock.sendRequestWasCalled).toNot(beCalled())
                }
            }
            
            context("when DataStore missing response model") {
                it("should call network service") {
                    // given
                    dataStoreMock.shareholderListModel = nil
                    // when
                    _ = provider.fetchShareholderList()
                    // then
                    expect(networkServiceMock.sendRequestWasCalled).toEventually(beCalledOnce())
                }
            }
            
            context("when successful response") {
                it("should return response model") {
                    // given
                    networkServiceMock.sendRequestCompletionStub = .success(TestData.model)
                    // when
                    let result = provider.fetchShareholderList()
                    // then
                    expect(result.value).toEventually(equal(TestData.model))
                }
            }
            
            context("when failure response") {
                it("should return error") {
                    // given
                    networkServiceMock.sendRequestCompletionStub = .failure(TestData.error)
                    // when
                    let result = provider.fetchShareholderList()
                    // then
                    expect(result.error).toEventually(matchError(TestData.error))
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
