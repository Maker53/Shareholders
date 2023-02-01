//
// InstalmentPaymentInfo Translator
// Generated on 23/11/2020 by gen v0.4.3
//

import AlfaFoundation

struct InstalmentPaymentInfoTranslator: Translator {
    let instalmentPaymentTranslator: AnyTranslator<InstalmentPayment>

    init(
        instalmentPaymentTranslator: AnyTranslator<InstalmentPayment> = .init(InstalmentPaymentTranslator())
    ) {
        self.instalmentPaymentTranslator = instalmentPaymentTranslator
    }

    func translateFrom(dictionary json: [String: Any]) throws -> InstalmentPaymentInfo {
        let paymentPeriodNumber: Int = try json.get(DTOKeys.paymentPeriodNumber)
        let payment = try instalmentPaymentTranslator.translateFrom(dictionary: json.get(DTOKeys.payment))
        return InstalmentPaymentInfo(
            paymentPeriodNumber: paymentPeriodNumber,
            payment: payment
        )
    }

    func translateToDictionary(_ object: InstalmentPaymentInfo) -> [String: Any] {
        let json = fromDTO(
            DTOKeys.self,
            [
                .paymentPeriodNumber: object.paymentPeriodNumber,
                .payment: instalmentPaymentTranslator.translateToDictionary(from: object.payment),
            ]
        )
        return json
    }
}

extension InstalmentPaymentInfoTranslator {
    enum DTOKeys: String {
        case paymentPeriodNumber
        case payment
    }
}
