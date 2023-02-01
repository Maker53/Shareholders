//
// InstalmentListResponseTranslator Tests
// Generated on 17/09/2020 by gen v0.4.0
//

import AlfaFoundation
import TestAdditions

@testable import Installments

final class InstalmentListResponseTranslatorTests: QuickSpec {
    override func spec() {
        var translator: InstalmentListResponseTranslator!

        beforeEach {
            translator = InstalmentListResponseTranslator()
        }

        describe(".translateFromDictionary") {
            it("should throw error for invalid DTO") {
                expect {
                    try translator.translateFrom(dictionary: TestData.emptyDTO)
                }.to(throwError())
            }
            it("should return data model for valid DTO") {
                expect {
                    try translator.translateFrom(dictionary: TestData.listValidDTO)
                }.to(equal(TestData.listValidModel))
            }
        }
    }
}

extension InstalmentListResponseTranslatorTests {
    enum TestData {
        static let listKeys = InstalmentListResponseTranslator.DTOKeys.self
        static let emptyDTO: [String: Any] = [:]
        static let listValidModel = InstalmentListResponse.Seeds.value
        static let listValidDTO: [String: Any] = [
            listKeys.instalments.rawValue: [validDTO, validDTO],
        ]

        static let keys = InstalmentTranslator.DTOKeys.self
        static let validModel = Instalment.Seeds.value
        static let validDTO: [String: Any] = [
            keys.id.rawValue: validModel.uid,
            keys.title.rawValue: validModel.title,
            keys.termInMonths.rawValue: validModel.termInMonths,
            keys.amount.rawValue: AmountTranslator().translateToDictionary(from: validModel.amount),
            keys.paymentInfo.rawValue: InstalmentPaymentInfoTranslator()
                .translateToDictionary(from: validModel.paymentInfo),
            keys.account.rawValue: accountsTypeDTO,
            keys.payments.rawValue: InstalmentFullPaymentTranslator().translateToArray(validModel.payments),
            keys.startDate.rawValue: DateFormatter(dateFormat: "yyyy-MM-dd").string(for: validModel.startDate) as Any,
            keys.endDate.rawValue: DateFormatter(dateFormat: "yyyy-MM-dd").string(for: validModel.endDate) as Any,
            keys.agreementNumber.rawValue: validModel.agreementNumber,
            keys.earlyRepaymentAvailable.rawValue: validModel.earlyRepaymentAvailable,
            keys.earlyRepaymentApplicationInProcessing.rawValue: validModel.earlyRepaymentApplicationInProcessing,
            keys.cancellationAvailable.rawValue: validModel.isCancellationAvailable,
        ]

        static let accountWithCard = AccountWithCards.Seeds.creditCardAccount
        static let amount = Amount(20_000, minorUnits: 100, currency: .rur)
        static let amountDTO = AmountTranslator().translateToDictionary(amount)
        static let paymentAmount = Amount(1_633_982, minorUnits: 100, currency: .rur)
        static let paymentAmountDTO = AmountTranslator().translateToDictionary(paymentAmount)
        static let creditInfoDTO: [String: Any] = [
            "nextPaymentDate": "2017-07-19",
            "payment": [
                "debt": paymentAmountDTO,
                "next": paymentAmountDTO,
                "overdue": paymentAmountDTO,
            ],
            "actualRateRounded": 0.23,
        ]
        static let accountsTypeDTO: [String: Any] = [
            "amount": amountDTO,
            "description": accountWithCard.account.description,
            "number": accountWithCard.account.number,
            "type": accountWithCard.account.type,
            "creditInfo": creditInfoDTO,
            "isAmountHidden": true,
            "cards":
                [
                    [
                        "id": "0000",
                        "title": "Best card",
                        "isBlocked": false,
                        "isVirtual": false,
                        "isCombo": false,
                        "maskedNumber": "･･1234",
                        "skinUrl": "\(Constants.BaseURL.com)",
                        "iconContent": ["code": "value"],
                    ],
                    [
                        "id": "0003",
                        "isBlocked": false,
                        "isVirtual": false,
                        "isCombo": false,
                        "maskedNumber": "･･4567",
                    ],
                    [
                        "id": "0006",
                        "isBlocked": false,
                        "isVirtual": false,
                        "isCombo": false,
                        "maskedNumber": "･･4321",
                        "skinUrl": "\(Constants.BaseURL.com)",
                        "title": "My super card",
                    ],
                ],
        ]
    }
}
