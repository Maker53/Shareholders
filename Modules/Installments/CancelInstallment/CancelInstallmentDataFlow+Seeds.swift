//  Created by Assylkhan Turan on 15/08/2022.

import ABUIComponents

extension CancelInstallment {
    enum Seeds {
        static let titleViewModel = TextView.ViewModel(
            leftTextViewModel: DefaultTextLabelViewModel(
                text: L10n.CancelInstallment.title,
                typography: .headlineMedium,
                textColor: appearance.palette.textPrimary,
                numberOfLines: 0
            ),
            insets: UIEdgeInsets(
                top: appearance.mSpace,
                left: appearance.extendedHorizontalMargin,
                bottom: appearance.xsSpace,
                right: appearance.extendedHorizontalMargin
            )
        )
        static let emptyTitleViewModel = TextView.ViewModel(
            leftTextViewModel: DefaultTextLabelViewModel(
                text: String.empty,
                textColor: .clear
            ),
            insets: .zero
        )
        static let textViewRowViewModel = TextView.ViewModel(
            leftTextViewModel: DefaultTextLabelViewModel(
                text: L10n.CancelInstallment.cancelTimeTitle,
                typography: .paragraphPrimaryMedium,
                textColor: appearance.palette.textPrimary,
                numberOfLines: 0
            ),
            insets: appearance.textViewInsets
        )

        static let appearance = Appearance(); struct Appearance: Grid, Theme {
            var textViewInsets: UIEdgeInsets {
                UIEdgeInsets(
                    top: .zero,
                    left: extendedHorizontalMargin,
                    bottom: xsSpace,
                    right: extendedHorizontalMargin
                )
            }
        }
    }
}
