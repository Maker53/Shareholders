//  Created by Lyudmila Danilchenko on 17/08/2020.

import ABUIComponents
import SharedProtocolsAndModels

protocol InstalmentListPresentationLogic: AnyObject {
    func presentError(_ response: InstalmentList.LoadingError.Response)
    func presentInstalmentList(_ response: InstalmentList.PresentModuleData.Response)
    func presentPlusButton(_ response: InstalmentList.PresentPlusButton.Reponse)
    func presentNewInstalment(_ response: InstalmentList.PresentNewInstalmentData.Response)
    func presentEmptyState(_ response: InstalmentList.PresentEmptyState.Response)
    func presentInstallmentDetails(_ response: InstalmentList.PresentInstallmentDetails.Response)
}

final class InstalmentListPresenter: InstalmentListPresentationLogic {
    // MARK: - Properties

    weak var viewController: InstalmentListDisplayLogic?
    private let amountFormatter: AmountFormatterProtocol
    private let skinBuilder: BuildsSkinImageSource

    // MARK: - init

    init(
        amountFormatter: AmountFormatterProtocol = AmountFormatter(),
        skinBuilder: BuildsSkinImageSource = SkinImageSourceBuilder()
    ) {
        self.amountFormatter = amountFormatter
        self.skinBuilder = skinBuilder
    }

    // MARK: - InstalmentListPresentationLogic

    func presentError(_ response: InstalmentList.LoadingError.Response) {
        let model: DefaultEmptyViewModel = .init(
            icon: .init(icon: .image(UIImage.assets.art_telecom_m_black)),
            title: L10n.InstalmentList.Error.Network.title,
            subtitle: response.description
        )
        viewController?.displayError(.init(model: model, description: response.description))
    }

    func presentInstalmentList(_ response: InstalmentList.PresentModuleData.Response) {
        viewController?.displayInstalments(map(response))
    }

    func presentPlusButton(_ response: InstalmentList.PresentPlusButton.Reponse) {
        viewController?.displayPlusButton(
            .init(shouldPresentButton: response.shouldPresentButton)
        )
    }

    func presentEmptyState(_ response: InstalmentList.PresentEmptyState.Response) {
        let icon: ImageSource = .image(UIImage.assets.glyph_installment_m.withRenderingMode(.alwaysTemplate))
        let title: String
        let subtitle: String
        let buttonViewModel: EmptyViewButtonViewModel?

        switch response.offersState {
        case [.hasCreditOffer, .hasDebitOffer]:
            title = L10n.InstalmentList.EmptyState.Titles.withAnyOffer
            subtitle = L10n.InstalmentList.EmptyState.Subtitles.creditAndDebitOffers
            buttonViewModel = EmptyViewButtonViewModel(
                title: L10n.InstalmentList.EmptyState.newInstalmentButtonTitle
            )
        case .hasCreditOffer:
            title = L10n.InstalmentList.EmptyState.Titles.withAnyOffer
            subtitle = L10n.InstalmentList.EmptyState.Subtitles.onlyCreditOffer
            buttonViewModel = EmptyViewButtonViewModel(
                title: L10n.InstalmentList.EmptyState.newInstalmentButtonTitle
            )
        case .hasDebitOffer:
            title = L10n.InstalmentList.EmptyState.Titles.withAnyOffer
            subtitle = L10n.InstalmentList.EmptyState.Subtitles.onlyDebitOffer
            buttonViewModel = EmptyViewButtonViewModel(
                title: L10n.InstalmentList.EmptyState.newInstalmentButtonTitle
            )
        default:
            title = L10n.InstalmentList.EmptyState.Titles.withoutOffers
            subtitle = L10n.InstalmentList.EmptyState.Subtitles.withoutOffers
            buttonViewModel = EmptyViewButtonViewModel(
                title: L10n.InstalmentList.EmptyState.understandButtonTitle
            )
        }

        let viewModel = DefaultEmptyViewModel(
            icon: .init(icon: icon),
            title: title,
            subtitle: subtitle,
            firstButtonViewModel: buttonViewModel
        )

        viewController?.displayEmptyView(.init(emptyViewViewModel: viewModel))
    }

    func presentNewInstalment(_ response: InstalmentList.PresentNewInstalmentData.Response) {
        switch (response.creditOffers.instalmentOffers.isEmpty, response.debitOffers.instalmentOffers.isEmpty) {
        case (false, false):
            viewController?.displayNewInstallmentSelection(.init(actions: createActions(with: response)))
        case (false, true):
            viewController?.displayNewInstalment(.init(offers: response.creditOffers, installmentType: .credit))
        case (true, false):
            viewController?.displayNewInstalment(.init(offers: response.debitOffers, installmentType: .debit))
        case (true, true):
            viewController?.dismiss()
        }
    }

    func presentInstallmentDetails(_ response: InstalmentList.PresentInstallmentDetails.Response) {
        viewController?.displayInstallmentDetails(response)
    }
}

private extension InstalmentListPresenter {
    func createActions(with response: InstalmentList.PresentNewInstalmentData.Response) -> [UIAlertAction] {
        [
            UIAlertAction(
                title: L10n.InstalmentList.SelectNewInstallmentType.creditInstallmentAction,
                style: .default,
                handler: { [weak self] _ in
                    self?.viewController?.displayNewInstalment(
                        .init(
                            offers: response.creditOffers,
                            installmentType: .credit
                        )
                    )
                }
            ),
            UIAlertAction(
                title: L10n.InstalmentList.SelectNewInstallmentType.debitInstallmentAction,
                style: .default,
                handler: { [weak self] _ in
                    self?.viewController?.displayNewInstalment(
                        .init(
                            offers: response.debitOffers,
                            installmentType: .debit
                        )
                    )
                }
            ),
            UIAlertAction(
                title: L10n.InstalmentList.SelectNewInstallmentType.cancelAction,
                style: .cancel,
                handler: nil
            ),
        ]
    }

    func map(_ response: InstalmentList.PresentModuleData.Response) -> InstalmentList.PresentModuleData.ViewModel {
        .init(
            sections: [
                makePaymentSection(response),
                makeCreditSection(response),
                makeDebitSection(response),
            ].compactMap { $0 }
        )
    }

    func makeCreditSection(_ response: InstalmentList.PresentModuleData.Response) -> InstallmentListSection? {
        let creditCells: [InstallmentListSection.Cell] = response.creditInstallments.map {
            .installment(makeProgressWidget(with: $0, type: .credit))
        }
        return creditCells.isNotEmpty ? .init(title: L10n.InstalmentList.CreditSection.title, cells: creditCells) : nil
    }

    func makeDebitSection(_ response: InstalmentList.PresentModuleData.Response) -> InstallmentListSection? {
        let debitCells: [InstallmentListSection.Cell] = response.debitInstallments.map {
            .debitInstallment(makeProgressWidget(with: $0, type: .debit))
        }
        return debitCells.isNotEmpty ? .init(title: L10n.InstalmentList.DebitSection.title, cells: debitCells) : nil
    }

    func makePaymentSection(_ response: InstalmentList.PresentModuleData.Response) -> InstallmentListSection? {
        guard let sum = response.paymentSum,
              (response.creditInstallments + response.debitInstallments).count > 1
        else { return nil }

        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFontOfSize22,
        ]

        let amountViewModel = DataViewModel(
            dataContent: OldDataContentViewModel(
                title: L10n.InstalmentList.PaymentSum.title,
                subtitleAttributed: NSAttributedString(string: "\(money: sum)", attributes: subtitleAttributes)
            ),
            icon: .init()
        )

        return .init(title: nil, cells: [.amount(amountViewModel)])
    }

    func amountStringFrom(obj: Any?) -> String {
        guard let totalDebtString = amountFormatter.string(for: obj)
        else { return .empty }
        return totalDebtString
    }

    func makeAmountString(for amount: Amount) -> String {
        let totalDebtString = amountStringFrom(obj: ComponentAmount(amount: amount))
        let amountWithCurrencyString = amountFormatter.appendCurrencySymbol(to: totalDebtString)
        return "\(amountWithCurrencyString)"
    }

    func makeInstalmentAmount(with instalment: Instalment) -> InstalmentAmountViewModel {
        let instalmentAmount = instalment.amount
        let debtAmount = instalment.paymentInfo.payment.debtAmount
        let alreadyAmount: Amount = instalmentAmount - debtAmount
        let amountProgressLeft = makeAmountString(for: alreadyAmount)
        let amountProgressRight = makeAmountString(for: instalmentAmount)
        let decimalProgress = alreadyAmount.decimalNormalized / instalmentAmount.decimalNormalized
        let progress = (decimalProgress as NSDecimalNumber).doubleValue
        let amountSubtitle = AmountTextFieldFormatter(
            currency: .init(debtAmount.currency),
            integerPartFont: LabelStyle.ActionPrimaryMedium.font,
            fractionalPartFont: LabelStyle.ParagraphPrimaryMedium.font
        ).format(from: ComponentAmount(amount: debtAmount)) ?? NSAttributedString()
        let amountProgress = InstalmentAmountViewModel(
            dataContentViewModel: DataContentViewModel
                .create(
                    from: .style(
                        .revert,
                        content: .init(
                            title: L10n.InstalmentList.remainsToPay,
                            subtitle: amountSubtitle
                        )
                    )
                ),
            progress: progress,
            amountProgressLeft: amountProgressLeft,
            amountProgressRight: amountProgressRight
        )
        return amountProgress
    }

    func dateString(with date: Date?) -> String {
        date?.dateWithDayMonthAsWord() ?? .empty
    }

    func makeIconView(skinURI: String?) -> ImageSource {
        skinBuilder.buildSkinImageSource(
            skinURI: skinURI,
            placeholder: UIImage.assetsCatalog.account_card_image_placeholder
        )
    }

    func makeProgressWidget(with instalment: Instalment, type: InstallmentType) -> InstalmentListCellViewModel {
        let nextPaymentDateString = dateString(with: instalment.paymentInfo.payment.paymentDate)
        let nextPaymentAmount = instalment.paymentInfo.payment.paymentAmount
        let nextPaymentAmountString = makeAmountString(for: nextPaymentAmount)
        let nextPayment = L10n.InstalmentList.NextPayment.before(nextPaymentDateString, nextPaymentAmountString)
        let icon: ImageSource
        switch type {
        case .credit:
            icon = makeIconView(skinURI: instalment.account.accountWithCards.cards.first?.skinURI)
        case .debit, .promotional:
            icon = .init()
        }
        let instalmentAmount = makeInstalmentAmount(with: instalment)

        let progressWidget = InstalmentListCellViewModel(
            id: instalment.uid,
            title: instalment.title,
            iconView: icon,
            amountProgress: instalmentAmount,
            nextPaymentTitle: L10n.InstalmentList.nextPayment,
            nextPayment: nextPayment,
            instalment: instalment
        )
        return progressWidget
    }
}
