//
// Instalment+Seeds
// Generated on 24/08/2021 by gen v0.6.11
//

import AlfaFoundation
import SharedProtocolsAndModels

extension Instalment {
    enum Seeds {
        static let value = Instalment(
            uid: "123456",
            title: "My super instalment 1",
            amount: Amount(6_000_000, minorUnits: 100),
            termInMonths: 6,
            paymentInfo: InstalmentPaymentInfo.Seeds.value,
            account: .credit(CreditAccount.Seeds.accountWithCreditCard),
            payments: [InstalmentFullPayment.Seeds.value],
            startDate: Date(timeIntervalSince1970: 1_500_411_600),
            endDate: Date(timeIntervalSince1970: 1_500_411_600),
            agreementNumber: "12345678",
            earlyRepaymentAvailable: true,
            earlyRepaymentApplicationInProcessing: false,
            isCancellationAvailable: false
        )
        static let valueRepaymentNotAvailable = Instalment(
            uid: "123456",
            title: "My super instalment 1",
            amount: Amount(6_000_000, minorUnits: 100),
            termInMonths: 6,
            paymentInfo: InstalmentPaymentInfo.Seeds.value,
            account: .credit(CreditAccount.Seeds.accountWithCreditCard),
            payments: [InstalmentFullPayment.Seeds.value],
            startDate: Date(timeIntervalSince1970: 1_500_411_600),
            endDate: Date(timeIntervalSince1970: 1_500_411_600),
            agreementNumber: "12345678",
            earlyRepaymentAvailable: false,
            earlyRepaymentApplicationInProcessing: false,
            isCancellationAvailable: false
        )
        static let valueRepaymentNotAvailableNoDebt = Instalment(
            uid: "123456",
            title: "My super instalment 1",
            amount: Amount(6_000_000, minorUnits: 100),
            termInMonths: 6,
            paymentInfo: InstalmentPaymentInfo.Seeds.value,
            account: .credit(CreditAccount.Seeds.accountWithCreditCardWithoutDebt),
            payments: [InstalmentFullPayment.Seeds.value],
            startDate: Date(timeIntervalSince1970: 1_500_411_600),
            endDate: Date(timeIntervalSince1970: 1_500_411_600),
            agreementNumber: "12345678",
            earlyRepaymentAvailable: false,
            earlyRepaymentApplicationInProcessing: false,
            isCancellationAvailable: false
        )
        static let valueRepaymentInProcessing = Instalment(
            uid: "123456",
            title: "My super instalment 1",
            amount: Amount(6_000_000, minorUnits: 100),
            termInMonths: 6,
            paymentInfo: InstalmentPaymentInfo.Seeds.value,
            account: .credit(CreditAccount.Seeds.accountWithCreditCard),
            payments: [InstalmentFullPayment.Seeds.value],
            startDate: Date(timeIntervalSince1970: 1_500_411_600),
            endDate: Date(timeIntervalSince1970: 1_500_411_600),
            agreementNumber: "12345678",
            earlyRepaymentAvailable: false,
            earlyRepaymentApplicationInProcessing: true,
            isCancellationAvailable: false
        )
        static let valueRepaymentInProcessingNoDebt = Instalment(
            uid: "123456",
            title: "My super instalment 1",
            amount: Amount(6_000_000, minorUnits: 100),
            termInMonths: 6,
            paymentInfo: InstalmentPaymentInfo.Seeds.value,
            account: .credit(CreditAccount.Seeds.accountWithCreditCardWithoutDebt),
            payments: [InstalmentFullPayment.Seeds.value],
            startDate: Date(timeIntervalSince1970: 1_500_411_600),
            endDate: Date(timeIntervalSince1970: 1_500_411_600),
            agreementNumber: "12345678",
            earlyRepaymentAvailable: true,
            earlyRepaymentApplicationInProcessing: true,
            isCancellationAvailable: false
        )
        static let valueNoCreditAccount = Instalment(
            uid: "123456",
            title: "My super instalment 1",
            amount: Amount(6_000_000, minorUnits: 100),
            termInMonths: 6,
            paymentInfo: InstalmentPaymentInfo.Seeds.value,
            account: .shared(SharedAccount.Seeds.ownAccount),
            payments: [InstalmentFullPayment.Seeds.value],
            startDate: Date(timeIntervalSince1970: 1_500_411_600),
            endDate: Date(timeIntervalSince1970: 1_500_411_600),
            agreementNumber: "12345678",
            earlyRepaymentAvailable: false,
            earlyRepaymentApplicationInProcessing: false,
            isCancellationAvailable: false
        )
        static let valueCancellationAvailable = Instalment(
            uid: "123456",
            title: "My super instalment 1",
            amount: Amount(6_000_000, minorUnits: 100),
            termInMonths: 6,
            paymentInfo: InstalmentPaymentInfo.Seeds.value,
            account: .credit(CreditAccount.Seeds.accountWithCreditCard),
            payments: [InstalmentFullPayment.Seeds.value],
            startDate: Date(timeIntervalSince1970: 1_500_411_600),
            endDate: Date(timeIntervalSince1970: 1_500_411_600),
            agreementNumber: "12345678",
            earlyRepaymentAvailable: false,
            earlyRepaymentApplicationInProcessing: false,
            isCancellationAvailable: true
        )
    }
}
