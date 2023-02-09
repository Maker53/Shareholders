// Created by Станислав on 09.02.2023.

import TestAdditions
@testable import Shareholders

final class ShareholderListDataStoreTests: QuickSpec {
    override func spec() {
        var dataStore: ShareholderListDataStore!
        
        beforeEach {
            dataStore = ShareholderListDataStore()
        }
        
        describe(".purge") {
            it("should purge DataStore") {
                // given
                dataStore.shareholderListModel = TestData.shareholderList
                // when
                dataStore.purge()
                // then
                expect(dataStore.shareholderListModel).to(beNil())
            }
        }
    }
}

// MARK: - TestData

private extension ShareholderListDataStoreTests {
    enum TestData {
        static let shareholderList = ShareholderList.Seeds.values
    }
}
