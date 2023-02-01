//  Created by Lyudmila Danilchenko on 11.09.2020.

import ABUIComponents
import SharedProtocolsAndModels

// секции
struct DetailInfoSection: Equatable {
    /// Заголовок секции
    let title: String?
    /// Вью модели ячеек секции
    var cells: [Rows]

    enum Rows: Equatable {
        case amountProgress(InstalmentAmountViewModel)
        case dataViews(DataViewModel)
        case cards(CardViewModel)
        case separator
        case banner(BannerTextViewModel)
        case rightIconDataView(InstalmentDetailPopUpViewModel)
        case cancelBanner(BannerWrapper.ViewModel)
    }
}

// вьюмодель для ячеек с карточкой
public struct CardViewModel: CardContentRepresentable, SmallOldCardIconViewModel, Equatable {
    public let title: String?
    public let value: String?
    public let hasApplePay: Bool
    public let subtitle: String?
    public let backgroundImage: ImageSource
    public let cardNumber: String?
}
