//
// InstalmentPaymentInfoTranslator Tests
// Generated on 23/11/2020 by gen v0.4.3
//

import AlfaFoundation
import TestAdditions

@testable import Installments

final class InstalmentPaymentInfoTranslatorTests: QuickSpec {
    override func spec() {
        var translator: InstalmentPaymentInfoTranslator!

        beforeEach {
            translator = InstalmentPaymentInfoTranslator()
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

extension InstalmentPaymentInfoTranslatorTests {
    enum TestData {
        static let keys = InstalmentPaymentInfoTranslator.DTOKeys.self
        static let emptyDTO: [String: Any] = [:]
        static let validModel = InstalmentPaymentInfo.Seeds.value
        static let validDTO: [String: Any] = [
            keys.paymentPeriodNumber.rawValue: validModel.paymentPeriodNumber,
            keys.payment.rawValue: InstalmentPaymentTranslator().translateToDictionary(from: validModel.payment),
        ]
    }
}
