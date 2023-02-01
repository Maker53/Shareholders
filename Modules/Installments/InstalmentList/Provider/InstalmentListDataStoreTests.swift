//  Created by Lyudmila Danilchenko on 21.09.2020.

import TestAdditions

@testable import Installments

final class InstalmentListDataStoreTests: QuickSpec {
    override func spec() {
        var dataStore: InstalmentListDataStore!

        beforeEach {
            dataStore = InstalmentListDataStore()

            dataStore.instalmentOffersModelWithType[.debit] = .init(instalmentOffers: [], shouldShowLanding: false)
            dataStore.instalmentOffersModelWithType[.credit] = .init(instalmentOffers: [], shouldShowLanding: false)
        }

        describe(".purge") {
            it("should purge datastore") {
                // when
                dataStore.purge()
                // then
                expect(dataStore.instalmentListModelWithType[.credit]!).to(beNil())
                expect(dataStore.instalmentOffersModelWithType[.credit]!).to(beNil())
                expect(dataStore.instalmentListModelWithType[.debit]!).to(beNil())
                expect(dataStore.instalmentOffersModelWithType[.debit]!).to(beNil())
            }
        }
    }
}
