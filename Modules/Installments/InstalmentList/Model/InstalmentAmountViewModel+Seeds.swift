//  Created by Lyudmila Danilchenko on 23.09.2020.

import ABUIComponents
import AMSharedProtocolsAndModels

extension InstalmentAmountViewModel {
    enum Seeds {
        static let componentAmount: ComponentAmount = .init(
            1_633_982,
            minorUnits: 100,
            currency: .init(
                raw: "RUR",
                code: 810,
                symbol: "₽"
            )
        )

        static let amountAttributed = AmountTextFieldFormatter(
            currency: componentAmount.currency,
            integerPartFont: LabelStyle.ActionPrimaryMedium.font,
            fractionalPartFont: LabelStyle.ParagraphPrimaryMedium.font
        ).format(from: componentAmount) ?? NSAttributedString()

        static let value = InstalmentAmountViewModel(
            dataContentViewModel: DataContentViewModel
                .create(
                    from: .style(
                        .revert,
                        content: .init(
                            title: "Осталось выплатить",
                            subtitle: amountAttributed
                        )
                    )
                ),
            progress: 0.727_669_666_666_666_7,
            amountProgressLeft: "43 660,18 ₽",
            amountProgressRight: "60 000 ₽"
        )
    }
}
