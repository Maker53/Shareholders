//  Created by Assylkhan Turan on 26.07.2022.

import TestAdditions

@testable import Installments

final class InstalmentTypeTests: QuickSpec {
    override func spec() {
        describe(".rawValue") {
            it("should check values") {
                expect(InstallmentType.self).to(beEqualSnapshot(matching: { $0.allCases }))
            }
        }
    }
}
