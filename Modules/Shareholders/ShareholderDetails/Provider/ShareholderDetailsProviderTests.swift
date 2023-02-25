// Created by Станислав on 08.02.2023.

import TestAdditions
import AlfaNetworking
import NetworkKit
@testable import Shareholders

final class ShareholderDetailsProviderTests: QuickSpec {
    override func spec() {
        var dataStoreMock: StoresShareholderListMock!
        var provider: ShareholderDetailsProvider!
        
        beforeEach {
            dataStoreMock = .init()
            provider = .init(dataStore: dataStoreMock)
        }
        
        describe(".fetchShareholderDetails") {
            context("when dataStore contains model") {
                it("should return correct model") {
                    // given
                    dataStoreMock.shareholderListModelStub = TestData.shareholderListModel
                    // when
                    let result = provider.fetchShareholderDetails(id: TestData.modelID)
                    // then
                    expect(dataStoreMock.getShareholderListModelWasCalled).to(beCalledOnce())
                    expect(result.value).to(equal(TestData.model))
                }
            }
            
            context("when dataStore doesn't contain model") {
                it("should return error") {
                    // given
                    dataStoreMock.shareholderListModelStub = TestData.nilModel
                    // when
                    let result = provider.fetchShareholderDetails(id: TestData.modelID)
                    // then
                    expect(dataStoreMock.getShareholderListModelWasCalled).to(beCalledOnce())
                    expect(result.error).to(matchError(TestData.error))
                }
            }
        }
    }
}

// MARK: - TestData

private extension ShareholderDetailsProviderTests {
    enum TestData {
        static let shareholderListModel = ShareholderList.Seeds.values
        static let nilModel: ShareholderList? = nil
        static let model = Shareholder.Seeds.value
        static let error: ServiceError = .other
        static let modelID = model.id
    }
}
