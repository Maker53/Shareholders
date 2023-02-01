//  Created by Андрей Фокин on 07.10.2022.

import PropertyWrappers
import SharedProtocolsAndModels

@frozen
/// Тип дебетовой рассрочки
public enum DebitOfferType: String, Decodable, CaseIterable {
    case standard = "Standard"
    case promotional = "Promotional"
}

/// Модель предложений рассрочки
public struct InstalmentOffer: Decodable, Equatable {
    /// Идентификатор оффера(предложения)
    let id: UniqueIdentifier
    /// Счёт
    let account: AccountsType?
    /// Признак наличия основного договора
    @Defaulted<FallbackStrategy.False>
    private(set) var hasInstallmentBaseAgreement: Bool
    /// Тип дебетовой рассрочки
    let offerType: DebitOfferType?
    /// Дебетовый баннер
    let banner: DebitBanner?
}

/// Баннер рассрочки
struct DebitBanner: Equatable, Decodable {
    /// Текст баннера
    let title: String
}
