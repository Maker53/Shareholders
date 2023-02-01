//
// InstalmentPayment Model
// Generated on 02/09/2021 by gen v0.6.11
//

import AlfaFoundation

/// Модель платежа по рассрочке
struct InstalmentPayment: Equatable {
    /// Дата платежа
    let paymentDate: Date?
    /// Сумма платежа
    let paymentAmount: Amount
    /// Сумма задолженности
    let debtAmount: Amount
    /// Сумма комиссии в этом месяце
    let commissionAmount: Amount
}
