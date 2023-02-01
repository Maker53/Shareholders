//
// InstalmentPaymentInfo+Seeds
// Generated on 23/11/2020 by gen v0.4.3
//

import AlfaFoundation

extension InstalmentPaymentInfo {
    enum Seeds {
        static let value = InstalmentPaymentInfo(
            paymentPeriodNumber: 6,
            payment: InstalmentPayment.Seeds.value
        )
    }
}
