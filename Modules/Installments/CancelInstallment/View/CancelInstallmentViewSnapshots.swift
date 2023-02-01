//  Created by Рамазанов Виталий Глебович on 27/08/2021.

import ABUIComponents
import TestAdditions

@testable import Installments

final class CancelInstallmentViewSnapshots: QuickSpec {
    override func spec() {
        var view: CancelInstallmentView!

        beforeEach {
            view = CancelInstallmentView()
        }

        describe(".configure") {
            it("should look good") {
                // when
                view.configure(TestData.viewModel)
                // then
                expect(view).to(
                    beEqualSnapshot("CancelInstallmentViewSnapshot_normal"),
                    layout: .frameForFullScreen
                )
            }
        }
    }
}

private extension CancelInstallmentViewSnapshots {
    enum TestData {
        static let comissionRefundViewModel = DataViewModel(
            dataContent: .init(
                title: "title",
                value: "value"
            ),
            icon: .init(
                icon: .image(.assets.glyph_bigArrowLeftLine_m.withRenderingMode(.alwaysTemplate))
            )
        )
        static let textViewViewModel = CancelInstallment.Seeds.textViewRowViewModel
        static let redTextViewModel = DataViewModel(
            dataContent: .init(
                title: L10n.CancelInstallment.cancelRedText,
                titleColor: appearance.palette.textAccent
            ),
            icon: .init(icon: .image(UIImage.assets.glyph_alertCircle_m_negative))
        )
        static let documentViewModel = DataViewModel(
            dataContent: .init(
                title: L10n.CancelInstallment.cancelDocumentTitle
            ),
            icon: .init(
                icon: .image(UIImage.assets.glyph_document_m.with(tintColor: appearance.palette.graphicSecondary)),
                backgroundColor: appearance.palette.specialbgNulled
            )
        )
        static let viewModel = CancelInstallment.PresentModuleData.ViewModel(
            titleViewModel: CancelInstallment.Seeds.titleViewModel,
            buttonTitle: L10n.CancelInstallment.buttonTitle,
            sections: [
                .init(
                    header: nil,
                    rows: [
                        .textView(textViewViewModel),
                        .comissionRefund(comissionRefundViewModel),
                        .redText(redTextViewModel),
                    ]
                ),
                .init(
                    header: "title",
                    rows: [
                        .document(documentViewModel),
                    ]
                ),
            ],
            parameters: .init(email: .empty, inputError: nil, agreementNumber: "123", installmentNumber: "123")
        )

        static let appearance = Appearance(); struct Appearance: Grid, Theme { }
    }
}
