//
// InstalmentPayment+Seeds
// Generated on 02/09/2021 by gen v0.6.11
//

import AlfaFoundation

extension InstalmentPayment {
    enum Seeds {
        static let value = InstalmentPayment(
            paymentDate: Date(timeIntervalSince1970: 1_500_411_600),
            paymentAmount: Amount(1_633_982, minorUnits: 100),
            debtAmount: Amount(1_633_982, minorUnits: 100),
            commissionAmount: Amount.Seeds.model
        )
    }
}
