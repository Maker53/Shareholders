//  Created by Lyudmila Danilchenko  on 23.09.2020.
///   InstalmentListCellViewModel:
///
///   Телик и Сонька (title)             🏞(iconView)
///                                             ]
///   Осталось выплатить                        |
///   40 000,50 руб                             |
///   ========--------------------------------  | (amountProgress)
///   10 000 руб                 50 000,50 руб  |
///                                             ]
///   Следующий платеж (nextPaymentTitle)
///   12 августа, 4 650 руб (nextPayment)
///

import ABUIComponents
import SharedProtocolsAndModels

/// Вьюмодель для ячейки Рассрочки
struct InstalmentListCellViewModel: ProgressWidgetViewModelRepresentable {
    let id: String
    let title: String
    let iconView: ImageSource
    let amountProgress: AmountProgressViewModelRepresentable
    let nextPaymentTitle: String
    let nextPayment: String
    let instalment: Instalment
}

// MARK: - Equatable

extension InstalmentListCellViewModel: Equatable {
    static func == (lhs: InstalmentListCellViewModel, rhs: InstalmentListCellViewModel) -> Bool {
        lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.iconView == rhs.iconView &&
            lhs.nextPaymentTitle == rhs.nextPaymentTitle &&
            lhs.nextPayment == rhs.nextPayment &&
            lhs.instalment == rhs.instalment &&
            lhs.amountProgress.dataContentViewModel == rhs.amountProgress.dataContentViewModel &&
            lhs.amountProgress.amountProgressLeft == rhs.amountProgress.amountProgressLeft &&
            lhs.amountProgress.amountProgressRight == rhs.amountProgress.amountProgressRight &&
            lhs.amountProgress.progress == rhs.amountProgress.progress &&
            lhs.amountProgress.progressAppearance == rhs.amountProgress.progressAppearance
    }
}
