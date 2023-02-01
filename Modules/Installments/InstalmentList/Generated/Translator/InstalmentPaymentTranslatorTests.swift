//
// InstalmentPaymentTranslator Tests
// Generated on 02/09/2021 by gen v0.6.11
//

import AlfaFoundation
import TestAdditions

@testable import Installments

final class InstalmentPaymentTranslatorTests: QuickSpec {
    override func spec() {
        var translator: InstalmentPaymentTranslator!

        beforeEach {
            translator = InstalmentPaymentTranslator()
        }

        describe(".translateFromDictionary") {
            it("should throw error for invalid DTO") {
                expect {
                    try translator.translateFrom(dictionary: TestData.emptyDTO)
                }.to(throwError())
            }
            it("should return data model for valid DTO") {
                expect {
                    try translator.translateFrom(dictionary: TestData.validDTO)
                }.to(equal(TestData.validModel))
            }
            it("should return data model for valid DTO without paymentDate") {
                expect {
                    try translator.translateFrom(dictionary: TestData.validDTOWithoutPaymentDate)
                }.to(equal(TestData.validModelWithoutPaymentDate))
            }
        }

        describe(".translateToDictionary") {
            it("should return valid DTO") {
                // when
                let dictionary = translator.translateToDictionary(TestData.validModel)
                // then
                expect {
                    try translator.translateFrom(dictionary: dictionary)
                }.to(equal(TestData.validModel))
            }
        }
    }
}

private extension InstalmentPaymentTranslatorTests {
    enum TestData {
        static let keys = InstalmentPaymentTranslator.DTOKeys.self
        static let emptyDTO: [String: Any] = [:]
        static let validModel = InstalmentPayment.Seeds.value
        static let validDTO: [String: Any] = [
            keys.paymentAmount.rawValue: AmountTranslator().translateToDictionary(from: validModel.paymentAmount),
            keys.debtAmount.rawValue: AmountTranslator().translateToDictionary(from: validModel.debtAmount),
            keys.paymentDate.rawValue: DateFormatter(dateFormat: "yyyy-MM-dd").string(for: validModel.paymentDate) as Any,
            keys.commissionAmount.rawValue: AmountTranslator().translateToDictionary(from: validModel.commissionAmount),
        ]
        static let validModelWithoutPaymentDate = InstalmentPayment(
            paymentDate: nil,
            paymentAmount: validModel.paymentAmount,
            debtAmount: validModel.debtAmount,
            commissionAmount: validModel.commissionAmount
        )
        static let validDTOWithoutPaymentDate: [String: Any] = [
            keys.paymentAmount.rawValue: AmountTranslator().translateToDictionary(from: validModel.paymentAmount),
            keys.debtAmount.rawValue: AmountTranslator().translateToDictionary(from: validModel.debtAmount),
            keys.commissionAmount.rawValue: AmountTranslator().translateToDictionary(from: validModel.commissionAmount),
        ]
    }
}
