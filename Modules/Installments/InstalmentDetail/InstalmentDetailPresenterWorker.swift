import ABUIComponents
import SharedProtocolsAndModels

protocol InstallmentDetailPresenterWorkerProtocol: AnyObject {
    typealias Section = DetailInfoSection
    typealias Row = Section.Rows
    func makeDataSections(installment: Instalment, installmentType: InstallmentType) -> [Section]
    func makeEarlyRepaymentSections(installment: Instalment, installmentType: InstallmentType, isFeatureAvailable: Bool) -> [Section]
}

final class InstallmentDetailPresenterWorker {
    private let appearance = Appearance(); struct Appearance: Theme { }
    private let cardNumberBuilder: BuildsCardNumber
    let skinBuilder: BuildsSkinImageSource

    init(
        skinBuilder: BuildsSkinImageSource = SkinImageSourceBuilder(),
        cardNumberBuilder: BuildsCardNumber = ShortCardNumberBuilder()
    ) {
        self.skinBuilder = skinBuilder
        self.cardNumberBuilder = cardNumberBuilder
    }
}

// MARK: - InstallmentDetailPresenterWorkerProtocol

extension InstallmentDetailPresenterWorker: InstallmentDetailPresenterWorkerProtocol {
    func makeDataSections(installment: Instalment, installmentType: InstallmentType) -> [Section] {
        var cells = [
            makeAmountRow(installment: installment),
            makeTermRow(installment: installment),
            makeNextPaymentRow(installment: installment),
            makePaymentDateRow(installment: installment),
            makeInstallmentEndDateRow(installment: installment),
        ] + makeDestinationRow(installment: installment, installmentType: installmentType)
        if installment.isCancellationAvailable {
            cells.append(makeCancelBannerRow())
        }
        return [Section(title: nil, cells: cells)]
    }

    func makeEarlyRepaymentSections(installment: Instalment, installmentType: InstallmentType, isFeatureAvailable: Bool) -> [Section] {
        switch installmentType {
        case .debit, .promotional:
            return []
        case .credit:
            return [
                Section(
                    title: nil,
                    cells: makeCreditEarlyRepaymentSections(
                        installment: installment,
                        installmentType: installmentType,
                        isFeatureAvailable: isFeatureAvailable
                    )
                ),
            ]
        }
    }
}

private extension InstallmentDetailPresenterWorker {
    // Data sections

    func makeAmountRow(installment: Instalment) -> Row {
        let installmentAmount = installment.amount
        let debtAmount = installment.paymentInfo.payment.debtAmount
        let alreadyAmount: Amount = installmentAmount - debtAmount
        let amountProgressLeft = "\(money: alreadyAmount)"
        let amountProgressRight = "\(money: installmentAmount)"
        let decimalProgress = alreadyAmount.decimalNormalized / installmentAmount.decimalNormalized
        let progress = (decimalProgress as NSDecimalNumber).doubleValue
        let amountSubtitle = AmountTextFieldFormatter(
            currency: .init(debtAmount.currency),
            integerPartFont: LabelStyle.ActionPrimaryMedium.font,
            fractionalPartFont: LabelStyle.ParagraphPrimaryMedium.font
        ).format(from: debtAmount) ?? NSAttributedString()
        let viewModel = InstalmentAmountViewModel(
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
        return .amountProgress(viewModel)
    }

    func makeTermRow(installment: Instalment) -> Row {
        let viewModel = DataViewModel(
            dataContent: .init(
                title: L10n.Installments.InstalmentDetail.earlyPaymentBannerDebt,
                subtitle: makeTermString(term: installment.termInMonths)
            ),
            icon: .init()
        )
        return .dataViews(viewModel)
    }

    func makeNextPaymentRow(installment: Instalment) -> Row {
        let viewModel = DataViewModel(
            dataContent: .init(
                title: L10n.Installments.InstalmentDetail.paymentAmount,
                subtitle: "\(money: installment.paymentInfo.payment.paymentAmount)"
            ),
            icon: .init()
        )
        return .dataViews(viewModel)
    }

    func makePaymentDateRow(installment: Instalment) -> Row {
        let viewModel = DataViewModel(
            dataContent: .init(
                title: L10n.Installments.InstalmentDetail.paymentDate,
                subtitle: installment.paymentInfo.payment.paymentDate?.dateWithDayMonthAsWord() ?? .empty
            ),
            icon: .init()
        )
        return .dataViews(viewModel)
    }

    func makeInstallmentEndDateRow(installment: Instalment) -> Row {
        let viewModel = DataViewModel(
            dataContent: .init(
                title: L10n.Installments.InstalmentDetail.lastPaymentDate,
                subtitle: installment.endDate.convertToString(dateFormat: Date.dateWithoutTimePatternInversed)
            ),
            icon: .init()
        )
        return .dataViews(viewModel)
    }

    func makeDestinationRow(installment: Instalment, installmentType: InstallmentType) -> [Row] {
        switch installmentType {
        case .credit:
            return makeCreditDestinationRows(installment: installment)
        case .debit, .promotional:
            return makeDebitDestinationRows(installment: installment)
        }
    }

    func makeCancelBannerRow() -> Row {
        .cancelBanner(
            .create(
                from: .style(
                    .strokeWithContentInteractions,
                    content: .init(
                        backgroundColor: appearance.palette.backgroundPrimary,
                        backgroundColorHighlighted: appearance.palette.backgroundPrimary,
                        borderColor: appearance.palette.borderTertiary
                    )
                )
            )
        )
    }

    // Early Repayment sections

    func makeCreditEarlyRepaymentSections(
        installment: Instalment,
        installmentType _: InstallmentType,
        isFeatureAvailable: Bool
    ) -> [Row] {
        guard case let .credit(creditAccount) = installment.account,
              isFeatureAvailable,
              !installment.earlyRepaymentAvailable,
              !installment.isCancellationAvailable else {
            return []
        }

        let repaymentInfoViewModel = InstalmentDetailPopUpViewModel(
            title: L10n.Installments.InstalmentDetail.earlyPaymentInfo,
            rightIcon: .init(
                icon: ImageSource.image(UIImage.assets.glyph_informationCircle_m).with(tintColor: appearance.palette.graphicPrimary)
            )
        )

        let cardDebt = creditAccount.creditInfo.amountDebt

        if !installment.earlyRepaymentAvailable,
           !installment.earlyRepaymentApplicationInProcessing,
           cardDebt.withoutMinorUnits == 0 {
            let repaymentBannerViewModel = BannerTextViewModel(
                subtitle: L10n.Installments.InstalmentDetail.earlyPaymentBannerNoFunds
            )

            return [
                .separator,
                .banner(repaymentBannerViewModel),
                .rightIconDataView(repaymentInfoViewModel),
            ]
        }

        let repaymentBannerViewModel = BannerTextViewModel(
            subtitle: installment.earlyRepaymentApplicationInProcessing
                ? L10n.Installments.InstalmentDetail.earlyPaymentBannerProcessing
                : L10n.Installments.InstalmentDetail.earlyPaymentBannerDebt
        )

        guard !installment.earlyRepaymentApplicationInProcessing else {
            return [
                .separator,
                .banner(repaymentBannerViewModel),
            ]
        }

        let cardDebtViewModel = DataViewModel(
            dataContent: OldDataContentViewModel(
                title: L10n.Installments.InstalmentDetail.cardDebt,
                subtitle: "\(money: cardDebt)"
            ),
            icon: .init()
        )

        return [
            .separator,
            .banner(repaymentBannerViewModel),
            .dataViews(cardDebtViewModel),
            .rightIconDataView(repaymentInfoViewModel),
        ]
    }

    // Utils

    func makeCreditDestinationRows(installment: Instalment) -> [Row] {
        installment.account.accountWithCards.cards.map {
            .cards(
                .init(
                    title: $0.title,
                    value: $0.maskedNumber,
                    hasApplePay: false,
                    subtitle: L10n.Installments.InstalmentDetail.cardAccountTitle,
                    backgroundImage: skinBuilder.buildSkinImageSource(
                        skinURI: $0.skinURI,
                        placeholder: .init()
                    ),
                    cardNumber: cardNumberBuilder.buildCardNumber(from: $0.maskedNumber)
                )
            )
        }
    }

    func makeDebitDestinationRows(installment: Instalment) -> [Row] {
        [
            .cards(
                .init(
                    title: installment.account.accountWithCards.account.description,
                    value: installment.account.accountWithCards.account.number,
                    hasApplePay: false,
                    subtitle: L10n.Installments.InstalmentDetail.cardAccountTitle,
                    backgroundImage: ImageSource.image(
                        UIImage.assets.glyph_rubIos_m.with(tintColor: appearance.palette.graphicSecondary)
                    ).withContentMode(.center),
                    cardNumber: nil
                )
            ),
        ]
    }

    func makeTermString(term: Int) -> String {
        var calendar = Calendar.current
        calendar.locale = .russianLocale
        let formatter = DateComponentsFormatter()
        formatter.calendar = calendar
        formatter.unitsStyle = .full
        let components = DateComponents(month: term)
        return formatter.string(from: components) ?? .empty
    }
}
