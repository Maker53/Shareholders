//
// InstalmentFullPaymentTranslator Tests
// Generated on 23/11/2020 by gen v0.4.3
//

import AlfaFoundation
import TestAdditions

@testable import Installments

final class InstalmentFullPaymentTranslatorTests: QuickSpec {
    override func spec() {
        var translator: InstalmentFullPaymentTranslator!

        beforeEach {
            translator = InstalmentFullPaymentTranslator()
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

extension InstalmentFullPaymentTranslatorTests {
    enum TestData {
        static let keys = InstalmentFullPaymentTranslator.DTOKeys.self
        static let emptyDTO: [String: Any] = [:]
        static let validModel = InstalmentFullPayment.Seeds.value
        static let validDTO: [String: Any] = [
            keys.paymentAmount.rawValue: AmountTranslator().translateToDictionary(from: validModel.paymentAmount),
            keys.debtAmount.rawValue: AmountTranslator().translateToDictionary(from: validModel.debtAmount),
            keys.commissionAmount.rawValue: AmountTranslator().translateToDictionary(from: validModel.commissionAmount),
            keys.paymentDate.rawValue: DateFormatter(dateFormat: "yyyy-MM-dd").string(for: validModel.paymentDate) as Any,
        ]
        static let validModelWithoutPaymentDate = InstalmentFullPayment(
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
