//  Created by Андрей Фокин on 07.10.2022.

import TestAdditions

@testable import Installments

final class InstallmentOfferTest: QuickSpec {
    override func spec() {
        describe(".rawValue") {
            it("should check values") {
                expect(DebitOfferType.self).to(beEqualSnapshot(matching: { $0.allCases }))
            }
        }
    }
}
