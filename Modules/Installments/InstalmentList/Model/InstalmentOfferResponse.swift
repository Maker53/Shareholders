//  Created by Андрей Фокин on 12.10.2022.

import SharedProtocolsAndModels

/// Модель списка офферов (предложений) рассрочки
public struct InstalmentOfferResponse: Equatable, Decodable {
    /// Массив моделей офферов (предложений) рассрочки
    let instalmentOffers: [InstalmentOffer]
    /// Следует ли показывать лендинг
    let shouldShowLanding: Bool

    public init(instalmentOffers: [InstalmentOffer], shouldShowLanding: Bool) {
        self.instalmentOffers = instalmentOffers
        self.shouldShowLanding = shouldShowLanding
    }

    enum CodingKeys: String, CodingKey {
        case instalmentOffers
        case shouldShowLanding = "showLanding"
    }
}
