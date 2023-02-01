//  Created by Рамазанов Виталий Глебович on 27/08/2021.

import ABUIComponents
import OperationConfirmation

protocol CancelInstallmentPresentationLogic: ConfirmationPresentationLogic {
    func presentError(_ errorType: CancelInstallment.ErrorType)
    func presentData(_ response: CancelInstallment.PresentModuleData.Response)
    func presentDocument(_ response: CancelInstallment.PresentDocument.Response)
    func presentResultScreen(_ response: CancelInstallment.Cancel.Response)
    func presentEmptyState()
}

final class CancelInstallmentPresenter: CancelInstallmentPresentationLogic {
    // MARK: - Properties

    private let appearance = Appearance(); struct Appearance: Theme, Grid {
        var textViewInsets: UIEdgeInsets {
            UIEdgeInsets(top: 0, left: extendedHorizontalMargin, bottom: xsSpace, right: extendedHorizontalMargin)
        }
    }

    weak var viewController: CancelInstallmentDisplayLogic?

    // MARK: - Confirmation FLow

    var confirmationController: ConfirmationDisplayLogic? {
        viewController
    }

    // MARK: - CancelInstallmentPresentationLogic

    func presentError(_ error: CancelInstallment.ErrorType) {
        switch error {
        case let .documentLoadingError(errorDescription):
            viewController?.displayDocumentError(errorDescription)
        case .loadingFailed:
            presentEmptyState()
        }
    }

    func presentData(_ response: CancelInstallment.PresentModuleData.Response) {
        viewController?.displayData(
            .init(
                titleViewModel: TextView.ViewModel(
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
                ),
                buttonTitle: L10n.CancelInstallment.buttonTitle,
                sections: makeSections(installment: response.installment, parameters: response.parameters),
                parameters: response.parameters
            )
        )
    }

    func presentDocument(_ response: CancelInstallment.PresentDocument.Response) {
        viewController?.displayDocument(response)
    }

    func presentResultScreen(_ response: CancelInstallment.Cancel.Response) {
        viewController?.displayResultScreen(
            makeResultScreenViewModel(isSuccess: response.isSuccess)
        )
    }

    func presentEmptyState() {
        let viewModel = DefaultEmptyViewModel(
            icon: .init(icon: .image(UIImage.assets.glyph_repearTool_m.withRenderingMode(.alwaysTemplate))),
            title: L10n.CancelInstallment.EmptyState.title,
            subtitle: L10n.CancelInstallment.EmptyState.subtitle,
            firstButtonViewModel: EmptyViewButtonViewModel(title: L10n.CancelInstallment.EmptyState.buttonTitle)
        )

        viewController?.displayEmptyState(viewModel)
    }
}

private extension CancelInstallmentPresenter {
    func makeSections(installment: Instalment, parameters: CancelInstallment.Parameters) -> [CancelInstallmentSection] {
        [
            CancelInstallmentSection(
                header: nil,
                rows: [
                    .textView(
                        TextView.ViewModel(
                            leftTextViewModel: DefaultTextLabelViewModel(
                                text: L10n.CancelInstallment.cancelTimeTitle,
                                typography: .paragraphPrimaryMedium,
                                textColor: appearance.palette.textPrimary,
                                numberOfLines: 0
                            ),
                            insets: appearance.textViewInsets
                        )
                    ),
                    .comissionRefund(
                        .init(
                            dataContent: .init(
                                title: L10n.CancelInstallment.comissionText,
                                value: "\(money: installment.paymentInfo.payment.commissionAmount)"
                            ),
                            icon: .init(icon: .image(UIImage.assets.glyph_bigArrowLeftLine_m.withRenderingMode(.alwaysTemplate)))
                        )
                    ),
                    .redText(
                        .init(
                            dataContent: .init(
                                title: L10n.CancelInstallment.cancelRedText,
                                titleColor: appearance.palette.textAccent
                            ),
                            icon: .init(icon: .image(UIImage.assets.glyph_alertCircle_m_negative))
                        )
                    ),
                ]
            ),
            CancelInstallmentSection(
                header: L10n.CancelInstallment.documentsTitle,
                rows: [
                    .document(
                        .init(
                            dataContent: .init(
                                title: L10n.CancelInstallment.cancelDocumentTitle
                            ),
                            icon: .init(
                                icon: .image(UIImage.assets.glyph_document_m.with(tintColor: appearance.palette.graphicSecondary)),
                                backgroundColor: appearance.palette.specialbgNulled
                            )
                        )
                    ),
                ]
            ),
            CancelInstallmentSection(
                header: nil,
                rows: [
                    .input(
                        .init(
                            errorMessage: parameters.inputError?.errorMessage,
                            formatter: CommonTextFieldFormatter(),
                            hint: nil,
                            isEnabled: true,
                            keyboardType: .emailAddress,
                            placeholder: L10n.Common.emailPlaceholer,
                            showClearButton: false,
                            text: parameters.email,
                            title: L10n.Common.emailTitle
                        )
                    ),
                ]
            ),
        ]
    }

    func makeResultScreenViewModel(isSuccess _: Bool) -> CancelInstallment.Cancel.ViewModel {
        let iconViewModel = IconViewViewModel(
            icon: .image(UIImage.assets.glyph_checkmark_m).with(tintColor: appearance.palette.staticGraphicLight),
            backgroundColor: appearance.palette.graphicPositive,
            titleColor: appearance.palette.staticGraphicLight,
            state: .default
        )
        return .init(model:
            .init(
                icon: iconViewModel,
                status: L10n.CancelInstallment.ResultScreen.title,
                info: L10n.CancelInstallment.ResultScreen.text,
                doneButtonTitle: L10n.CancelInstallment.ResultScreen.buttonTitle
            )
        )
    }
}
