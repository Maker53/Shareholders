//  Created by Lyudmila Danilchenko on 25/10/2020.

import ABUIComponents
import SharedProtocolsAndModels
import TestAdditions

@testable import Installments

final class InstallmentDetailPresenterWorkerTests: QuickSpec {
    override func spec() {
        var skinBuilderMock: BuildsSkinImageSourceMock!
        var cardNumberBuilderMock: BuildsCardNumberMock!
        var worker: InstallmentDetailPresenterWorker!

        beforeEach {
            skinBuilderMock = .init()
            cardNumberBuilderMock = BuildsCardNumberMock()
            worker = .init(skinBuilder: skinBuilderMock, cardNumberBuilder: cardNumberBuilderMock)

            skinBuilderMock.buildSkinImageSourceSkinURIPlaceholderStub = TestData.skinStub
            cardNumberBuilderMock.buildCardNumberFromStub = TestData.cardNumberStub
        }

        describe(".init") {
            context("with default parameters") {
                it("should init class properly") {
                    // when
                    worker = InstallmentDetailPresenterWorker()
                    // then
                    let builder: ShortCardNumberBuilder? = worker["cardNumberBuilder"]
                    expect(worker.skinBuilder).to(beAnInstanceOf(SkinImageSourceBuilder.self))
                    expect(builder).toNot(beNil())
                }
            }
        }

        describe(".makeDataSections") {
            context("when installment type is credit") {
                it("should return correct sections") {
                    // when
                    let sections = worker.makeDataSections(
                        installment: TestData.installment,
                        installmentType: TestData.creditType
                    )
                    // then
                    expect(sections).to(equal(TestData.MakeData.expectedCreditSections))
                    expect(cardNumberBuilderMock.buildCardNumberFromWasCalled).to(equal(TestData.MakeData.expectedCallsCount))
                }
            }
            context("when installment type is debit") {
                it("should return correct sections") {
                    // when
                    let sections = worker.makeDataSections(
                        installment: TestData.installment,
                        installmentType: TestData.debitType
                    )
                    // then
                    expect(sections).to(equal(TestData.MakeData.expectedDebitSections))
                }
            }
            context("when installment type is promotional") {
                it("should return correct sections") {
                    // when
                    let sections = worker.makeDataSections(
                        installment: TestData.installment,
                        installmentType: TestData.promotionalType
                    )
                    // then
                    expect(sections).to(equal(TestData.MakeData.expectedDebitSections))
                }
            }
            context("when installment cancellation is available") {
                it("should return correct sections") {
                    // when
                    let sections = worker.makeDataSections(
                        installment: TestData.cancelInstallment,
                        installmentType: TestData.creditType
                    )
                    // then
                    expect(sections).to(equal(TestData.MakeData.expectedCreditSectionsCancel))
                }
            }
        }

        describe(".makeEarlyRepaymentSections") {
            context("when installment type is debit") {
                it("should return empty array") {
                    // when
                    let sections = worker.makeEarlyRepaymentSections(
                        installment: TestData.installment,
                        installmentType: TestData.debitType,
                        isFeatureAvailable: true
                    )
                    // then
                    expect(sections).to(beEmpty())
                }
            }
            context("when installment type is promotional") {
                it("should return empty array") {
                    // when
                    let sections = worker.makeEarlyRepaymentSections(
                        installment: TestData.installment,
                        installmentType: TestData.promotionalType,
                        isFeatureAvailable: true
                    )
                    // then
                    expect(sections).to(beEmpty())
                }
            }

            describe(".makeRepaymentCells") {
                context("when FT disabled") {
                    it("should return empty array") {
                        // when
                        let sections = worker.makeEarlyRepaymentSections(
                            installment: TestData.installment,
                            installmentType: .credit,
                            isFeatureAvailable: false
                        )
                        // then
                        expect(sections.first?.cells).to(beEmpty())
                    }
                }

                context("when cancelation available") {
                    it("should return empty array") {
                        // when
                        let sections = worker.makeEarlyRepaymentSections(
                            installment: TestData.cancelInstallment,
                            installmentType: .credit,
                            isFeatureAvailable: true
                        )
                        // then
                        expect(sections.first?.cells).to(beEmpty())
                    }
                }

                context("when early repayment is not availble and early repayment is not in processing and no debt") {
                    it("should return banner with no-funds-text") {
                        // when
                        let sections = worker.makeEarlyRepaymentSections(
                            installment: TestData.MakeEarlyRepayment.instalmentNoFunds,
                            installmentType: .credit,
                            isFeatureAvailable: true
                        )
                        // then
                        expect(sections.first?.cells).to(equal(TestData.MakeEarlyRepayment.repaymentNoFundsCells))
                    }
                }

                context("when early repayment is not available") {
                    it("should return repayment cells") {
                        // when
                        let sections = worker.makeEarlyRepaymentSections(
                            installment: TestData.MakeEarlyRepayment.instalmentNoRepayment,
                            installmentType: .credit,
                            isFeatureAvailable: true
                        )
                        // then
                        expect(sections.first?.cells).to(equal(TestData.MakeEarlyRepayment.repaymentCells))
                    }
                }

                context("when has no credit account") {
                    it("should return empty array") {
                        // when
                        let sections = worker.makeEarlyRepaymentSections(
                            installment: TestData.MakeEarlyRepayment.instalmentNoCreditAccount,
                            installmentType: .credit,
                            isFeatureAvailable: true
                        )

                        // then
                        expect(sections.first?.cells).to(beEmpty())
                    }
                }

                context("when has no debt") {
                    context("when early repayment is in processing") {
                        it("should return empty array") {
                            // when
                            let sections = worker.makeEarlyRepaymentSections(
                                installment: TestData.MakeEarlyRepayment.instalmentInProcessingNoDebt,
                                installmentType: .credit,
                                isFeatureAvailable: true
                            )
                            // then
                            expect(sections.first?.cells).to(beEmpty())
                        }
                    }

                    it("should return empty array") {
                        // when
                        let sections = worker.makeEarlyRepaymentSections(
                            installment: TestData.MakeEarlyRepayment.instalmentInProcessingDebt,
                            installmentType: .credit,
                            isFeatureAvailable: true
                        )
                        // then
                        expect(sections.first?.cells).to(equal([.separator, TestData.MakeEarlyRepayment.repaymentProcessingBanner]))
                    }
                }

                it("should return correct empty array") {
                    // when
                    let sections = worker.makeEarlyRepaymentSections(
                        installment: TestData.installment,
                        installmentType: .credit,
                        isFeatureAvailable: true
                    )
                    expect(sections.first?.cells).to(beEmpty())
                }
            }
        }
    }
}

// swiftlint:disable non_localized_cyrillic_strings
extension InstallmentDetailPresenterWorker: PropertyReflectable { }

private extension InstallmentDetailPresenterWorkerTests {
    typealias Section = DetailInfoSection
    typealias Row = Section.Rows

    enum TestData {
        enum MakeEarlyRepayment {
            static let instalmentNoCreditAccount = Instalment.Seeds.valueNoCreditAccount
            static let instalmentNoRepayment = Instalment.Seeds.valueRepaymentNotAvailable
            static let instalmentNoFunds = Instalment.Seeds.valueRepaymentNotAvailableNoDebt
            static let instalmentInProcessingDebt = Instalment.Seeds.valueRepaymentInProcessing
            static let instalmentInProcessingNoDebt = Instalment.Seeds.valueRepaymentInProcessingNoDebt
            static let repaymentBannerNoFundsViewModel = BannerTextViewModel(
                subtitle: L10n.Installments.InstalmentDetail.earlyPaymentBannerNoFunds
            )
            static let popUpViewModel = InstalmentDetailPopUpViewModel(
                title: L10n.Installments.InstalmentDetail.earlyPaymentInfo,
                rightIcon: .init(
                    icon: ImageSource.image(UIImage.assets.glyph_informationCircle_m).with(tintColor: appearance.palette.graphicPrimary)
                )
            )
            static let repaymentNoFundsCells: [Row] = [
                .separator,
                .banner(repaymentBannerNoFundsViewModel),
                .rightIconDataView(popUpViewModel),
            ]
            static let repaymentBannerViewModel = BannerTextViewModel(
                subtitle: L10n.Installments.InstalmentDetail.earlyPaymentBannerDebt
            )
            static let debtViewModel = DataViewModel(
                dataContent: OldDataContentViewModel(
                    title: L10n.Installments.InstalmentDetail.cardDebt,
                    subtitle: "16 339,82 ₽"
                ),
                icon: .init()
            )
            static let repaymentCells: [Row] = [
                .separator,
                .banner(repaymentBannerViewModel),
                .dataViews(debtViewModel),
                .rightIconDataView(popUpViewModel),
            ]
            static let repaymentProcessingBannerViewModel = BannerTextViewModel(
                subtitle: L10n.Installments.InstalmentDetail.earlyPaymentBannerProcessing
            )
            static let repaymentProcessingBanner = Row.banner(
                repaymentProcessingBannerViewModel
            )
        }

        enum MakeData {
            static let progress: Double = {
                let alreadyPaid = installment.amount - installment.paymentInfo.payment.debtAmount
                let progress = alreadyPaid.decimalNormalized / installment.amount.decimalNormalized
                return (progress as NSDecimalNumber).doubleValue
            }()

            static let amountSubtitle = AmountTextFieldFormatter(
                currency: .init(installment.paymentInfo.payment.debtAmount.currency),
                integerPartFont: LabelStyle.ActionPrimaryMedium.font,
                fractionalPartFont: LabelStyle.ParagraphPrimaryMedium.font
            ).format(from: installment.paymentInfo.payment.debtAmount) ?? NSAttributedString()

            static let amountVM = InstalmentAmountViewModel(
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
                amountProgressLeft: "\(money: installment.amount - installment.paymentInfo.payment.debtAmount)",
                amountProgressRight: "\(money: installment.amount)"
            )
            static let termVM = DataViewModel(
                dataContent: .init(
                    title: L10n.Installments.InstalmentDetail.earlyPaymentBannerDebt,
                    subtitle: "6 месяцев"
                ),
                icon: .init()
            )
            static let nextPaymentVM = DataViewModel(
                dataContent: .init(
                    title: L10n.Installments.InstalmentDetail.paymentAmount,
                    subtitle: "\(money: installment.paymentInfo.payment.paymentAmount)"
                ),
                icon: .init()
            )
            static let nextPaymentDateVM = DataViewModel(
                dataContent: .init(
                    title: L10n.Installments.InstalmentDetail.paymentDate,
                    subtitle: installment.paymentInfo.payment.paymentDate?.dateWithDayMonthAsWord() ?? .empty
                ),
                icon: .init()
            )
            static let installmentEndVM = DataViewModel(
                dataContent: .init(
                    title: L10n.Installments.InstalmentDetail.lastPaymentDate,
                    subtitle: installment.endDate.convertToString(dateFormat: Date.dateWithoutTimePatternInversed)
                ),
                icon: .init()
            )
            static let cancelBanner: BannerWrapper.ViewModel = .create(
                from: .style(
                    .strokeWithContentInteractions,
                    content: .init(
                        backgroundColor: appearance.palette.backgroundPrimary,
                        backgroundColorHighlighted: appearance.palette.backgroundPrimary,
                        borderColor: appearance.palette.borderTertiary
                    )
                )
            )
            static let expectedCallsCount = installment.account.accountWithCards.cards.count
            static let expectedCardRows: [Row] = installment.account.accountWithCards.cards.map {
                .cards(
                    .init(
                        title: $0.title,
                        value: $0.maskedNumber,
                        hasApplePay: false,
                        subtitle: L10n.Installments.InstalmentDetail.cardAccountTitle,
                        backgroundImage: skinStub,
                        cardNumber: cardNumberStub
                    )
                )
            }

            static let expectedAccountRows: [Row] = [
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
            static let expectedCreditSections: [Section] = [
                .init(
                    title: nil,
                    cells: [
                        .amountProgress(amountVM),
                        .dataViews(termVM),
                        .dataViews(nextPaymentVM),
                        .dataViews(nextPaymentDateVM),
                        .dataViews(installmentEndVM),
                    ] + expectedCardRows
                ),
            ]
            static let expectedCreditSectionsCancel: [Section] = [
                .init(
                    title: nil,
                    cells: cellsWithCancelBanner
                ),
            ]
            static let cellsWithCancelBanner: [Row] = {
                var rows = [
                    .amountProgress(amountVM),
                    .dataViews(termVM),
                    .dataViews(nextPaymentVM),
                    .dataViews(nextPaymentDateVM),
                    .dataViews(installmentEndVM),
                ] + expectedCardRows
                rows.append(.cancelBanner(cancelBanner))
                return rows
            }()

            static let expectedDebitSections: [Section] = [
                .init(
                    title: nil,
                    cells: [
                        .amountProgress(amountVM),
                        .dataViews(termVM),
                        .dataViews(nextPaymentVM),
                        .dataViews(nextPaymentDateVM),
                        .dataViews(installmentEndVM),
                    ] + expectedAccountRows
                ),
            ]
        }

        static let cancelInstallment = Instalment.Seeds.valueCancellationAvailable
        static let cardNumberStub = "1234"
        static let creditType = InstallmentType.credit
        static let debitType = InstallmentType.debit
        static let promotionalType = InstallmentType.promotional
        static let installment = Instalment.Seeds.value
        static let skinStub = ImageSource()

        static let appearance = Appearance(); struct Appearance: Theme { }
    }
}
