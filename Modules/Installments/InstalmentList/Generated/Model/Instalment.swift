//
// Instalment Model
// Generated on 24/08/2021 by gen v0.6.11
//

import AlfaFoundation
import SharedProtocolsAndModels

/// Модель рассрочки
public struct Instalment: Equatable, UniqueIdentifiable {
    /// Идентификатор рассрочки
    public let uid: String
    /// Имя рассрочки, заданное пользователем
    let title: String
    /// Сумма рассрочки
    let amount: Amount
    /// Период рассрочки в месяцах
    let termInMonths: Int
    /// Информация о текущем платеже по рассрочке
    let paymentInfo: InstalmentPaymentInfo
    /// Счёт
    let account: AccountsType
    /// График платежей
    let payments: [InstalmentFullPayment]
    /// Дата начала рассрочки
    let startDate: Date
    /// Дата окончания рассрочки
    let endDate: Date
    /// Номер договора
    let agreementNumber: String
    /// Показывает доступно ли клиенту досрочное погашение
    let earlyRepaymentAvailable: Bool
    /// Показывает, что сегодня уже было совершено досрочное погашение
    let earlyRepaymentApplicationInProcessing: Bool
    /// Показывает доступна ли клиенту отмена рассрочки
    let isCancellationAvailable: Bool
}
