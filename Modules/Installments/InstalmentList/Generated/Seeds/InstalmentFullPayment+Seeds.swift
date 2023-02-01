//
// InstalmentFullPayment+Seeds
// Generated on 23/11/2020 by gen v0.4.3
//

import AlfaFoundation

extension InstalmentFullPayment {
    enum Seeds {
        static let value = InstalmentFullPayment(
            paymentDate: Date(timeIntervalSince1970: 1_500_411_600),
            paymentAmount: Amount(1_633_982, minorUnits: 100),
            debtAmount: Amount(1_633_982, minorUnits: 100),
            commissionAmount: Amount(1_633_982, minorUnits: 100)
        )
    }
}
