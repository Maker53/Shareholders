import TestAdditions

@testable import Installments

final class CancelInstallmentDataFlowTests: QuickSpec {
    override func spec() {
        describe(".errorMessage") {
            it("should return correct message") {
                // when
                let emptyError = CancelInstallment.InputError.empty.errorMessage
                let incorrectError = CancelInstallment.InputError.incorrect.errorMessage
                // then
                expect(emptyError).to(equal(L10n.Common.EmailError.emptyEmail))
                expect(incorrectError).to(equal(L10n.Common.EmailError.invalidEmail))
            }
        }
    }
}
