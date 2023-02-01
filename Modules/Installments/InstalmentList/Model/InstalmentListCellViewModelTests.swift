//  Created by Mika Fox on 09.10.2020.

import TestAdditions

@testable import Installments

final class InstalmentListCellViewModelTests: QuickSpec {
    override func spec() {
        describe(".equality") {
            context("arguments are equal") {
                it("should return true") {
                    // given
                    let lhs = InstalmentListCellViewModel.Seeds.value
                    let rhs = InstalmentListCellViewModel.Seeds.value
                    // when
                    let result = lhs == rhs
                    // then
                    expect(result).to(beTrue())
                }
            }

            context("arguments are not equal") {
                it("should return false") {
                    // given
                    let lhs = InstalmentListCellViewModel.Seeds.value
                    let rhs = InstalmentListCellViewModel.Seeds.otherValue
                    // when
                    let result = lhs == rhs
                    // then
                    expect(result).to(beFalse())
                }
            }
        }
    }
}
