//
// Instalment Translator
// Generated on 24/08/2021 by gen v0.6.11
//

import AlfaFoundation
import SharedProtocolsAndModels
import SharedServices

struct InstalmentTranslator: Translator {
    let amountTranslator: AnyTranslator<Amount>
    let instalmentPaymentInfoTranslator: AnyTranslator<InstalmentPaymentInfo>
    let accountsTypeTranslator: AnyTranslator<AccountsType>
    let instalmentFullPaymentTranslator: AnyTranslator<InstalmentFullPayment>
    let startDateDateFormatter: DateFormatter
    let endDateDateFormatter: DateFormatter

    // FIXME: временно, пока не договорились с мидлом о стандартном формате даты в контракте
    static var myDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter(dateFormat: "yyyy-MM-dd")
        dateFormatter.setISO8601Options()
        return dateFormatter
    }()

    init(
        amountTranslator: AnyTranslator<Amount> = .init(AmountTranslator()),
        instalmentPaymentInfoTranslator: AnyTranslator<InstalmentPaymentInfo> = .init(InstalmentPaymentInfoTranslator()),
        accountsTypeTranslator: AnyTranslator<AccountsType> = .init(AccountsTypeTranslator()),
        instalmentFullPaymentTranslator: AnyTranslator<InstalmentFullPayment> = .init(InstalmentFullPaymentTranslator()),
        startDateDateFormatter: DateFormatter = myDateFormatter,
        endDateDateFormatter: DateFormatter = myDateFormatter
    ) {
        self.amountTranslator = amountTranslator
        self.instalmentPaymentInfoTranslator = instalmentPaymentInfoTranslator
        self.accountsTypeTranslator = accountsTypeTranslator
        self.instalmentFullPaymentTranslator = instalmentFullPaymentTranslator
        self.startDateDateFormatter = startDateDateFormatter
        self.startDateDateFormatter.setISO8601Options()
        self.endDateDateFormatter = endDateDateFormatter
        self.endDateDateFormatter.setISO8601Options()
    }

    func translateFrom(dictionary json: [String: Any]) throws -> Instalment {
        let uid: String = try json.get(DTOKeys.id)
        let title: String = try json.get(DTOKeys.title)
        let termInMonths: Int = try json.get(DTOKeys.termInMonths)
        let agreementNumber: String = try json.get(DTOKeys.agreementNumber)
        let earlyRepaymentAvailable: Bool = try json.get(DTOKeys.earlyRepaymentAvailable)
        let earlyRepaymentApplicationInProcessing: Bool = try json.get(DTOKeys.earlyRepaymentApplicationInProcessing)
        let isCancellationAvailable: Bool = try json.get(DTOKeys.cancellationAvailable)
        let amount = try amountTranslator.translateFrom(dictionary: json.get(DTOKeys.amount))
        let paymentInfo = try instalmentPaymentInfoTranslator.translateFrom(dictionary: json.get(DTOKeys.paymentInfo))
        let account = try accountsTypeTranslator.translateFrom(dictionary: json.get(DTOKeys.account))
        let payments = try instalmentFullPaymentTranslator.translateFrom(array: json.get(DTOKeys.payments))
        guard let startDate: Date = startDateDateFormatter.date(for: try json.get(DTOKeys.startDate)) else {
            throw TranslatorError.invalidJSONObject
        }
        guard let endDate: Date = endDateDateFormatter.date(for: try json.get(DTOKeys.endDate)) else {
            throw TranslatorError.invalidJSONObject
        }
        return Instalment(
            uid: uid,
            title: title,
            amount: amount,
            termInMonths: termInMonths,
            paymentInfo: paymentInfo,
            account: account,
            payments: payments,
            startDate: startDate,
            endDate: endDate,
            agreementNumber: agreementNumber,
            earlyRepaymentAvailable: earlyRepaymentAvailable,
            earlyRepaymentApplicationInProcessing: earlyRepaymentApplicationInProcessing,
            isCancellationAvailable: isCancellationAvailable
        )
    }
}

extension InstalmentTranslator {
    enum DTOKeys: String {
        case id
        case title
        case amount
        case termInMonths
        case paymentInfo
        case account
        case payments
        case startDate
        case endDate
        case agreementNumber
        case earlyRepaymentAvailable
        case earlyRepaymentApplicationInProcessing
        case cancellationAvailable
    }
}
