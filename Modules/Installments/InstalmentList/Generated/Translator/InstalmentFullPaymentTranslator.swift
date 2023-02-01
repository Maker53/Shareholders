//
// InstalmentFullPayment Translator
// Generated on 23/11/2020 by gen v0.4.3
//

import AlfaFoundation

struct InstalmentFullPaymentTranslator: Translator {
    let amountTranslator: AnyTranslator<Amount>
    let paymentDateDateFormatter: DateFormatter
    // FIXME: временно, пока не договорились с мидлом о стандартном формате даты в контракте
    static var myDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter(dateFormat: "yyyy-MM-dd")
        dateFormatter.setISO8601Options()
        return dateFormatter
    }()

    init(
        amountTranslator: AnyTranslator<Amount> = .init(AmountTranslator()),
        paymentDateDateFormatter: DateFormatter = myDateFormatter
    ) {
        self.amountTranslator = amountTranslator
        self.paymentDateDateFormatter = paymentDateDateFormatter
        self.paymentDateDateFormatter.setISO8601Options()
    }

    func translateFrom(dictionary json: [String: Any]) throws -> InstalmentFullPayment {
        let paymentAmount = try amountTranslator.translateFrom(dictionary: json.get(DTOKeys.paymentAmount))
        let debtAmount = try amountTranslator.translateFrom(dictionary: json.get(DTOKeys.debtAmount))
        let commissionAmount = try amountTranslator.translateFrom(dictionary: json.get(DTOKeys.commissionAmount))
        let paymentDate: Date? = paymentDateDateFormatter.date(for: try? json.get(DTOKeys.paymentDate))
        return InstalmentFullPayment(
            paymentDate: paymentDate,
            paymentAmount: paymentAmount,
            debtAmount: debtAmount,
            commissionAmount: commissionAmount
        )
    }

    func translateToDictionary(_ object: InstalmentFullPayment) -> [String: Any] {
        var json = fromDTO(
            DTOKeys.self,
            [
                .paymentAmount: amountTranslator.translateToDictionary(from: object.paymentAmount),
                .debtAmount: amountTranslator.translateToDictionary(from: object.debtAmount),
                .commissionAmount: amountTranslator.translateToDictionary(from: object.commissionAmount),
            ]
        )
        json.setUnlessNil(paymentDateDateFormatter.string(for: object.paymentDate), forKey: DTOKeys.paymentDate)
        return json
    }
}

extension InstalmentFullPaymentTranslator {
    enum DTOKeys: String {
        case paymentDate
        case paymentAmount
        case debtAmount
        case commissionAmount
    }
}
