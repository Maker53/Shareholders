//  Created by Lyudmila Danilchenko on 23.09.2020.

import ABUIComponents
import SharedPlatformExtensions
import SharedProtocolsAndModels

extension InstalmentListCellViewModel {
    enum Seeds {
        static let value = InstalmentListCellViewModel(
            id: "123456",
            title: "My super instalment 1",
            iconView: .url(Constants.BaseURL.com, placeholder: UIImage.assetsCatalog.account_card_image_placeholder),
            amountProgress: InstalmentAmountViewModel.Seeds.value,
            nextPaymentTitle: "Следующий платёж",
            nextPayment: "До 19 июля, 16 339,82 ₽",
            instalment: Instalment.Seeds.value
        )

        static let otherValue = InstalmentListCellViewModel(
            id: "1234567",
            title: "Телек и сонька",
            iconView: .url(
                URL(string: "http://alfabank.ru/image")!,
                placeholder: UIImage.assetsCatalog.account_card_image_placeholder
            ),
            amountProgress: InstalmentAmountViewModel.Seeds.value,
            nextPaymentTitle: "Следующий платёж",
            nextPayment: "До 13 августа, 16 339,82 ₽",
            instalment: Instalment.Seeds.value
        )
        static let debitValue = InstalmentListCellViewModel(
            id: "123456",
            title: "My super instalment 1",
            iconView: .init(),
            amountProgress: InstalmentAmountViewModel.Seeds.value,
            nextPaymentTitle: "Следующий платёж",
            nextPayment: "До 19 июля, 16 339,82 ₽",
            instalment: Instalment.Seeds.value
        )
        static let debitOtherValue = InstalmentListCellViewModel(
            id: "1234567",
            title: "Телек и сонька",
            iconView: .init(),
            amountProgress: InstalmentAmountViewModel.Seeds.value,
            nextPaymentTitle: "Следующий платёж",
            nextPayment: "До 13 августа, 16 339,82 ₽",
            instalment: Instalment.Seeds.value
        )
    }
}
