//
// InstalmentOffer+Seeds
// Generated on 17/10/2020 by gen v0.4.3
//

import AlfaFoundation
import SharedProtocolsAndModels

extension InstalmentOffer {
    enum Seeds {
        static let value = InstalmentOffer(
            id: "123456",
            account: .credit(CreditAccount.Seeds.accountWithCreditCard),
            hasInstallmentBaseAgreement: true,
            offerType: .standard,
            banner: nil
        )
        static let valueNoBaseAgreement = InstalmentOffer(
            id: "123456",
            account: .credit(CreditAccount.Seeds.accountWithCreditCard),
            hasInstallmentBaseAgreement: false,
            offerType: .standard,
            banner: nil
        )
        static let valueDefault = InstalmentOffer(
            id: "221",
            account: .credit(CreditAccount.Seeds.defaultAccount),
            hasInstallmentBaseAgreement: false,
            offerType: .standard,
            banner: nil
        )
        static let valueWithoutDebt = InstalmentOffer(
            id: "567890",
            account: .credit(CreditAccount.Seeds.accountWithCreditCardWithoutDebt),
            hasInstallmentBaseAgreement: false,
            offerType: .standard,
            banner: nil
        )
        static let valuePromotionalWithBanner = InstalmentOffer(
            id: "123456",
            account: .credit(CreditAccount.Seeds.accountWithCreditCardWithoutDebt),
            hasInstallmentBaseAgreement: false,
            offerType: .promotional,
            banner: DebitBanner(title: "Test banner")
        )
        static let valuePromotionalWithoutBanner = InstalmentOffer(
            id: "123456",
            account: .credit(CreditAccount.Seeds.accountWithCreditCardWithoutDebt),
            hasInstallmentBaseAgreement: false,
            offerType: .promotional,
            banner: nil
        )
        static let valueWithNoAccount = InstalmentOffer(
            id: "70000875685",
            account: nil,
            hasInstallmentBaseAgreement: false,
            offerType: .promotional,
            banner: DebitBanner(title: "Test banner")
        )
        static let valueWithNoOfferType = InstalmentOffer(
            id: "70000875685",
            account: nil,
            hasInstallmentBaseAgreement: false,
            offerType: nil,
            banner: DebitBanner(title: "Test banner")
        )
    }
}
