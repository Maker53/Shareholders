//
// InstalmentPaymentInfo Model
// Generated on 23/11/2020 by gen v0.4.3
//

import AlfaFoundation

/// Модель информации о текущем платеже по рассрочке
struct InstalmentPaymentInfo: Equatable {
    /// Порядковый номер платежа по месяцам (например, шестой из двенадцати)
    let paymentPeriodNumber: Int
    /// Текущий платёж
    let payment: InstalmentPayment
}
