//
// InstalmentFullPayment Model
// Generated on 23/11/2020 by gen v0.4.3
//

import AlfaFoundation

/// Модель ежемесячного платежа по рассрочке с комиссией
struct InstalmentFullPayment: Equatable {
    /// Дата платежа
    let paymentDate: Date?
    /// Сумма платежа
    let paymentAmount: Amount
    /// Сумма задолженности по рассрочке
    let debtAmount: Amount
    /// Сумма комиссии в этом месяце
    let commissionAmount: Amount
}
