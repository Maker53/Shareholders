//  Created by Lyudmila Danilchenko on 17/08/2020.

import ABUIComponents
import Resources
import SharedProtocolsAndModels
import TestAdditions

@testable import Installments

final class InstalmentListPresenterTests: QuickSpec {
    override func spec() {
        var presenter: InstalmentListPresenter!
        var viewControllerMock: InstalmentListDisplayLogicMock!
        var skinBuilderMock: BuildsSkinImageSourceMock!

        beforeEach {
            skinBuilderMock = .init()
            presenter = InstalmentListPresenter(
                skinBuilder: skinBuilderMock
            )
            viewControllerMock = InstalmentListDisplayLogicMock()
            presenter.viewController = viewControllerMock
            skinBuilderMock.buildSkinImageSourceSkinURIPlaceholderStub = TestData.skinStub
        }

        describe(".init") {
            it("should set correct default parameters") {
                // given
                presenter = .init()
                // when
                let skinBuilder: SkinImageSourceBuilder? = presenter["skinBuilder"]
                let amountFormatter: AmountFormatter? = presenter["amountFormatter"]
                // then
                expect(skinBuilder).toNot(beNil())
                expect(amountFormatter).toNot(beNil())
            }
        }

        describe(".presentInstallmentDetails") {
            it("should ask view controller to present installment details") {
                // given
                let response = InstallmentDetailsContext.full(InstallmentDetailsModel(
                    installment: Instalment.Seeds.value,
                    installmentType: .credit,
                    isSeveralInstallments: false
                ))
                // when
                presenter.presentInstallmentDetails(response)
                // then
                expect(viewControllerMock.displayInstallmentDetailsWasCalled).to(beCalledOnce())
                expect(viewControllerMock.displayInstallmentDetailsReceivedViewModel).to(equal(response))
            }
        }

        describe(".presentInstalmentList") {
            context("when there is only one credit installment") {
                it("should make only one section") {
                    // when
                    presenter.presentInstalmentList(TestData.OneCreditInstallment.response)
                    // then
                    expect(viewControllerMock.displayInstalmentsWasCalled).to(beCalledOnce())
                    expect(viewControllerMock.displayInstalmentsReceivedViewModel).to(equal(TestData.OneCreditInstallment.viewModel))
                    expect(skinBuilderMock.buildSkinImageSourceSkinURIPlaceholderWasCalled).to(beCalledOnce())
                    expect(skinBuilderMock.buildSkinImageSourceSkinURIPlaceholderReceivedArguments?.skinURI)
                        .to(equal(TestData.expectedSkinURIString))
                    expect(skinBuilderMock.buildSkinImageSourceSkinURIPlaceholderReceivedArguments?.placeholder)
                        .to(equal(TestData.expectedSkinPlaceholder))
                }
            }
            context("when there is only one debit installment") {
                it("should make only one section") {
                    // when
                    presenter.presentInstalmentList(TestData.OneDebitInstallment.response)
                    // then
                    expect(viewControllerMock.displayInstalmentsWasCalled).to(beCalledOnce())
                    expect(viewControllerMock.displayInstalmentsReceivedViewModel).to(equal(TestData.OneDebitInstallment.viewModel))
                    expect(skinBuilderMock.buildSkinImageSourceSkinURIPlaceholderWasCalled)
                        .toNot(beCalled())
                }
            }
            context("when there is only one promotional installment") {
                it("should make only one section") {
                    // when
                    presenter.presentInstalmentList(TestData.OneDebitInstallment.response)
                    // then
                    expect(viewControllerMock.displayInstalmentsWasCalled).to(beCalledOnce())
                    expect(viewControllerMock.displayInstalmentsReceivedViewModel).to(equal(TestData.OneDebitInstallment.viewModel))
                    expect(skinBuilderMock.buildSkinImageSourceSkinURIPlaceholderWasCalled)
                        .toNot(beCalled())
                }
            }
            context("when there are some installments") {
                it("should make installment section and payment section") {
                    // when
                    presenter.presentInstalmentList(TestData.SomeDebitInstallment.response)
                    // then
                    expect(viewControllerMock.displayInstalmentsWasCalled).to(beCalledOnce())
                    expect(viewControllerMock.displayInstalmentsReceivedViewModel).to(equal(TestData.SomeDebitInstallment.viewModel))
                    expect(skinBuilderMock.buildSkinImageSourceSkinURIPlaceholderWasCalled)
                        .toNot(beCalled())
                }
                it("should make installment section and payment section") {
                    // when
                    presenter.presentInstalmentList(TestData.SomeCreditInstallments.response)
                    // then
                    expect(viewControllerMock.displayInstalmentsWasCalled).to(beCalledOnce())
                    expect(viewControllerMock.displayInstalmentsReceivedViewModel).to(equal(TestData.SomeCreditInstallments.viewModel))
                    expect(skinBuilderMock.buildSkinImageSourceSkinURIPlaceholderWasCalled)
                        .to(equal(2))
                    expect(skinBuilderMock.buildSkinImageSourceSkinURIPlaceholderReceivedArguments?.skinURI)
                        .to(equal(TestData.expectedSkinURIString))
                    expect(skinBuilderMock.buildSkinImageSourceSkinURIPlaceholderReceivedArguments?.placeholder)
                        .to(equal(TestData.expectedSkinPlaceholder))
                }
            }
            context("when there are credit and debit installments") {
                it("should make installment sections and payment section") {
                    // when
                    presenter.presentInstalmentList(TestData.BothInstallmentsTypes.response)
                    // then
                    expect(viewControllerMock.displayInstalmentsWasCalled).to(beCalledOnce())
                    expect(viewControllerMock.displayInstalmentsReceivedViewModel).to(equal(TestData.BothInstallmentsTypes.viewModel))
                    expect(skinBuilderMock.buildSkinImageSourceSkinURIPlaceholderWasCalled)
                        .to(beCalledOnce())
                    expect(skinBuilderMock.buildSkinImageSourceSkinURIPlaceholderReceivedArguments?.skinURI)
                        .to(equal(TestData.expectedSkinURIString))
                    expect(skinBuilderMock.buildSkinImageSourceSkinURIPlaceholderReceivedArguments?.placeholder)
                        .to(equal(TestData.expectedSkinPlaceholder))
                }
            }
        }

        describe(".presentError") {
            it("should ask view controller to present error") {
                // when
                presenter.presentError(InstalmentList.LoadingError.Response(description: TestData.errorDescription))
                // then
                expect(viewControllerMock.displayErrorWasCalled)
                    .to(beCalledOnce())
                expect(viewControllerMock.displayErrorReceivedViewModel?.model.subtitle)
                    .to(equal(TestData.localizedDescription))
                expect(viewControllerMock.displayErrorReceivedViewModel).to(equal(TestData.errorViewModel))
            }
        }

        describe(".presentPlusButton") {
            it("should ask view controller to display plus button") {
                // when
                presenter.presentPlusButton(.init(shouldPresentButton: true))
                // then
                expect(viewControllerMock.displayPlusButtonWasCalled)
                    .to(beCalledOnce())
                expect(viewControllerMock.displayPlusButtonReceivedViewModel?.shouldPresentButton)
                    .to(beTrue())
            }
        }

        describe(".presentEmptyStateModel") {
            context("when the state of offers contains both Debit and Credit") {
                it("should ask view controller to display empty view") {
                    // given
                    let response = TestData.PresentEmptyState.withCreditAndDebitResponse
                    // when
                    presenter.presentEmptyState(response)
                    // then
                    expect(viewControllerMock.displayEmptyViewWasCalled).to(beCalledOnce())
                    expect(viewControllerMock.displayEmptyViewReceivedViewModel)
                        .to(equal(TestData.PresentEmptyState.debitAndCreditOffersViewModel))
                }
            }

            context("when the state of offers contains only Credit") {
                it("should ask view controller to display empty view") {
                    // given
                    let response = TestData.PresentEmptyState.withCreditResponse
                    // when
                    presenter.presentEmptyState(response)
                    // then
                    expect(viewControllerMock.displayEmptyViewWasCalled).to(beCalledOnce())
                    expect(viewControllerMock.displayEmptyViewReceivedViewModel)
                        .to(equal(TestData.PresentEmptyState.onlyCreditOfferViewModel))
                }
            }

            context("when the state of offers contains only Debit") {
                it("should ask view controller to display empty view") {
                    // given
                    let response = TestData.PresentEmptyState.withDebitResponse
                    // when
                    presenter.presentEmptyState(response)
                    // then
                    expect(viewControllerMock.displayEmptyViewWasCalled).to(beCalledOnce())
                    expect(viewControllerMock.displayEmptyViewReceivedViewModel)
                        .to(equal(TestData.PresentEmptyState.onlyDebitOfferViewModel))
                }
            }

            context("when the state of offers contains neither Debit nor Credit") {
                it("should ask view controller to display empty view") {
                    // given
                    let response = TestData.PresentEmptyState.withoutOffersResponse
                    // when
                    presenter.presentEmptyState(response)
                    // then
                    expect(viewControllerMock.displayEmptyViewWasCalled).to(beCalledOnce())
                    expect(viewControllerMock.displayEmptyViewReceivedViewModel)
                        .to(equal(TestData.PresentEmptyState.withoutOffersViewModel))
                }
            }
        }

        describe(".presentNewInstalment") {
            context("when there are credit and debit offers") {
                it("should ask controller to display installment type selection action sheet") {
                    // when
                    presenter.presentNewInstalment(TestData.TwoTypeOffers.response)
                    // then
                    let viewModel = viewControllerMock.displayNewInstallmentSelectionReceivedViewModel
                    expect(viewControllerMock.displayNewInstallmentSelectionWasCalled).to(beCalledOnce())
                    expect(viewModel?.actions.count).to(equal(3))
                    expect(viewModel?.actions[0].title).to(equal(TestData.TwoTypeOffers.action1.title))
                    expect(viewModel?.actions[0].style).to(equal(TestData.TwoTypeOffers.action1.style))
                    expect(viewModel?.actions[1].title).to(equal(TestData.TwoTypeOffers.action2.title))
                    expect(viewModel?.actions[1].style).to(equal(TestData.TwoTypeOffers.action2.style))
                    expect(viewModel?.actions[2].title).to(equal(TestData.TwoTypeOffers.action3.title))
                    expect(viewModel?.actions[2].style).to(equal(TestData.TwoTypeOffers.action3.style))
                }
                it("should have correct action handler") {
                    // when
                    presenter.presentNewInstalment(TestData.TwoTypeOffers.response)
                    // then
                    let viewModel = viewControllerMock.displayNewInstallmentSelectionReceivedViewModel
                    viewModel?.actions[0].callHandlerBlock()
                    expect(viewControllerMock.displayNewInstalmentWasCalled).to(beCalledOnce())
                    expect(viewControllerMock.displayNewInstalmentReceivedViewModel)
                        .to(equal(.init(offers: TestData.TwoTypeOffers.response.creditOffers, installmentType: .credit)))
                }
                it("should have correct action handler") {
                    // when
                    presenter.presentNewInstalment(TestData.TwoTypeOffers.response)
                    // then
                    let viewModel = viewControllerMock.displayNewInstallmentSelectionReceivedViewModel
                    viewModel?.actions[1].callHandlerBlock()
                    expect(viewControllerMock.displayNewInstalmentWasCalled).to(beCalledOnce())
                    expect(viewControllerMock.displayNewInstalmentReceivedViewModel)
                        .to(equal(.init(offers: TestData.TwoTypeOffers.response.debitOffers, installmentType: .debit)))
                }
                it("should have correct action handler") {
                    // when
                    presenter.presentNewInstalment(TestData.TwoTypeOffers.response)
                    // then
                    let viewModel = viewControllerMock.displayNewInstallmentSelectionReceivedViewModel
                    viewModel?.actions[2].callHandlerBlock()
                    expect(viewControllerMock.displayNewInstalmentWasCalled).toNot(beCalled())
                }
            }
            context("when there are only credit/debit offers") {
                context("when there are only credit offers") {
                    it("should ask controller to display new installment") {
                        // when
                        presenter.presentNewInstalment(TestData.CreditOffers.response)
                        // then
                        expect(viewControllerMock.displayNewInstalmentWasCalled).to(beCalledOnce())
                        expect(viewControllerMock.displayNewInstalmentReceivedViewModel).to(equal(TestData.CreditOffers.viewModel))
                    }
                }
                context("when there are only debit offers") {
                    it("should ask controller to display new installment") {
                        // when
                        presenter.presentNewInstalment(TestData.DebitOffers.response)
                        // then
                        expect(viewControllerMock.displayNewInstalmentWasCalled).to(beCalledOnce())
                        expect(viewControllerMock.displayNewInstalmentReceivedViewModel).to(equal(TestData.DebitOffers.viewModel))
                    }
                }
            }
            context("when there are no offers") {
                it("should present error") {
                    // when
                    presenter.presentNewInstalment(TestData.NoOffers.response)
                    // then
                    expect(viewControllerMock.dismissWasCalled).to(beCalledOnce())
                }
            }
        }
    }
}

extension InstalmentListPresenter: PropertyReflectable { }

// swiftlint:disable non_localized_cyrillic_strings

private extension InstalmentListPresenterTests {
    enum TestData {
        enum TwoTypeOffers {
            static let response = InstalmentList.PresentNewInstalmentData.Response(
                creditOffers: InstalmentOfferResponse.Seeds.value,
                debitOffers: InstalmentOfferResponse.Seeds.value
            )
            static let action1 = UIAlertAction(
                title: L10n.InstalmentList.SelectNewInstallmentType.creditInstallmentAction,
                style: .default,
                handler: nil
            )
            static let action2 = UIAlertAction(
                title: L10n.InstalmentList.SelectNewInstallmentType.debitInstallmentAction,
                style: .default,
                handler: nil
            )
            static let action3 = UIAlertAction(
                title: L10n.InstalmentList.SelectNewInstallmentType.cancelAction,
                style: .cancel,
                handler: nil
            )
        }

        enum CreditOffers {
            static let response = InstalmentList.PresentNewInstalmentData.Response(
                creditOffers: InstalmentOfferResponse.Seeds.value,
                debitOffers: InstalmentOfferResponse.Seeds.emptyValue
            )
            static let viewModel = InstalmentList.PresentNewInstalmentData.ViewModel(
                offers: InstalmentOfferResponse.Seeds.value,
                installmentType: .credit
            )
        }

        enum DebitOffers {
            static let response = InstalmentList.PresentNewInstalmentData.Response(
                creditOffers: InstalmentOfferResponse.Seeds.emptyValue,
                debitOffers: InstalmentOfferResponse.Seeds.value
            )
            static let viewModel = InstalmentList.PresentNewInstalmentData.ViewModel(
                offers: InstalmentOfferResponse.Seeds.value,
                installmentType: .debit
            )
        }

        enum NoOffers {
            static let response = InstalmentList.PresentNewInstalmentData.Response(
                creditOffers: InstalmentOfferResponse.Seeds.emptyValue,
                debitOffers: InstalmentOfferResponse.Seeds.emptyValue
            )
            static let viewModel = InstalmentList.LoadingError.Response(
                description: Resources.L10n.APIClientError.somethingWentWrong
            )
        }

        enum OneDebitInstallment {
            static let response = InstalmentList.PresentModuleData.Response(
                paymentSum: nil,
                creditInstallments: [],
                debitInstallments: debitInstallments
            )
            static let viewModel = InstalmentList.PresentModuleData.ViewModel(
                sections: [
                    .init(title: "Деньги в рассрочку", cells: [.debitInstallment(InstalmentListCellViewModel.Seeds.debitValue)]),
                ]
            )
        }

        enum OneCreditInstallment {
            static let response = InstalmentList.PresentModuleData.Response(
                paymentSum: nil,
                creditInstallments: creditInstallments,
                debitInstallments: []
            )
            static let viewModel = InstalmentList.PresentModuleData.ViewModel(
                sections: [
                    .init(title: "Рассрочки кредитных карт", cells: [.installment(InstalmentListCellViewModel.Seeds.value)]),
                ]
            )
        }

        enum SomeDebitInstallment {
            static let response = InstalmentList.PresentModuleData.Response(
                paymentSum: Amount(1_633_982 * 2, minorUnits: 100),
                creditInstallments: [],
                debitInstallments: debitInstallments + debitInstallments
            )
            static let viewModel = InstalmentList.PresentModuleData.ViewModel(
                sections: [
                    .init(title: nil, cells: [.amount(paymentViewModel)]),
                    .init(
                        title: "Деньги в рассрочку",
                        cells: [
                            .debitInstallment(InstalmentListCellViewModel.Seeds.debitValue),
                            .debitInstallment(InstalmentListCellViewModel.Seeds.debitValue),
                        ]
                    ),
                ]
            )
        }

        enum SomeCreditInstallments {
            static let response = InstalmentList.PresentModuleData.Response(
                paymentSum: Amount(1_633_982 * 2, minorUnits: 100),
                creditInstallments: creditInstallments + creditInstallments,
                debitInstallments: []
            )
            static let viewModel = InstalmentList.PresentModuleData.ViewModel(
                sections: [
                    .init(title: nil, cells: [.amount(paymentViewModel)]),
                    .init(
                        title: "Рассрочки кредитных карт",
                        cells: [
                            .installment(InstalmentListCellViewModel.Seeds.value),
                            .installment(InstalmentListCellViewModel.Seeds.value),
                        ]
                    ),
                ]
            )
        }

        enum BothInstallmentsTypes {
            static let sum = Amount(1_633_982 * 2, minorUnits: 100)
            static let response = InstalmentList.PresentModuleData.Response(
                paymentSum: sum,
                creditInstallments: creditInstallments,
                debitInstallments: debitInstallments
            )
            static let viewModel = InstalmentList.PresentModuleData.ViewModel(
                sections: [
                    .init(title: nil, cells: [.amount(paymentViewModel)]),
                    .init(title: "Рассрочки кредитных карт", cells: [.installment(InstalmentListCellViewModel.Seeds.value)]),
                    .init(title: "Деньги в рассрочку", cells: [.debitInstallment(InstalmentListCellViewModel.Seeds.debitValue)]),
                ]
            )
        }

        enum PresentEmptyState {
            // MARK: Internal

            static let withCreditAndDebitResponse = InstalmentList.PresentEmptyState.Response(
                offersState: [.hasCreditOffer, .hasDebitOffer]
            )
            static let withCreditResponse = InstalmentList.PresentEmptyState.Response(
                offersState: [.hasCreditOffer]
            )
            static let withDebitResponse = InstalmentList.PresentEmptyState.Response(
                offersState: [.hasDebitOffer]
            )
            static let withoutOffersResponse = InstalmentList.PresentEmptyState.Response(
                offersState: []
            )
            static let debitAndCreditOffersViewModel = InstalmentList.PresentEmptyState.ViewModel(
                emptyViewViewModel: .init(
                    icon: .init(icon: defaultIconImageSource),
                    title: L10n.InstalmentList.EmptyState.Titles.withAnyOffer,
                    subtitle: L10n.InstalmentList.EmptyState.Subtitles.creditAndDebitOffers,
                    firstButtonViewModel: nonNilButtonViewModel
                )
            )
            static let onlyCreditOfferViewModel = InstalmentList.PresentEmptyState.ViewModel(
                emptyViewViewModel: .init(
                    icon: .init(icon: defaultIconImageSource),
                    title: L10n.InstalmentList.EmptyState.Titles.withAnyOffer,
                    subtitle: L10n.InstalmentList.EmptyState.Subtitles.onlyCreditOffer,
                    firstButtonViewModel: nonNilButtonViewModel
                )
            )
            static let onlyDebitOfferViewModel = InstalmentList.PresentEmptyState.ViewModel(
                emptyViewViewModel: .init(
                    icon: .init(icon: defaultIconImageSource),
                    title: L10n.InstalmentList.EmptyState.Titles.withAnyOffer,
                    subtitle: L10n.InstalmentList.EmptyState.Subtitles.onlyDebitOffer,
                    firstButtonViewModel: nonNilButtonViewModel
                )
            )
            static let withoutOffersViewModel = InstalmentList.PresentEmptyState.ViewModel(
                emptyViewViewModel: .init(
                    icon: .init(icon: defaultIconImageSource),
                    title: L10n.InstalmentList.EmptyState.Titles.withoutOffers,
                    subtitle: L10n.InstalmentList.EmptyState.Subtitles.withoutOffers,
                    firstButtonViewModel: okButtonViewModel
                )
            )

            // MARK: Private

            private static let defaultImage = UIImage.assets.glyph_installment_m.withRenderingMode(.alwaysTemplate)
            private static let defaultIconImageSource = ImageSource.image(defaultImage)
            private static let nonNilButtonViewModel = EmptyViewButtonViewModel(
                title: L10n.InstalmentList.EmptyState.newInstalmentButtonTitle
            )
            private static let okButtonViewModel = EmptyViewButtonViewModel(
                title: L10n.InstalmentList.EmptyState.understandButtonTitle
            )
        }

        static let expectedSkinPlaceholder = UIImage.assetsCatalog.account_card_image_placeholder
        static let expectedSkinURIString = Constants.BaseURL.com.absoluteString
        static let skinStub = ImageSource.url(Constants.BaseURL.com, placeholder: UIImage.assetsCatalog.account_card_image_placeholder)

        static let offers = [InstalmentOffer.Seeds.value]
        static let creditInstallments = [Instalment.Seeds.value]
        static let debitInstallments = [Instalment.Seeds.value]
        static let response = InstalmentList.PresentModuleData.Response(
            paymentSum: Amount.Seeds.model,
            creditInstallments: creditInstallments,
            debitInstallments: debitInstallments
        )
        static let paymentSum = Amount(3_267_964, minorUnits: 100, currency: .rub)
        static let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFontOfSize22,
        ]
        static let paymentViewModel = DataViewModel(
            dataContent: OldDataContentViewModel(
                title: "Сумма платежей в месяц",
                subtitleAttributed: NSAttributedString(
                    string: "\(money: paymentSum)",
                    attributes: subtitleAttributes
                )
            ),
            icon: .init()
        )
        static let viewModel = InstalmentList.PresentModuleData.ViewModel(
            sections: [
                .init(title: nil, cells: [.amount(paymentViewModel)]),
                .init(title: "Рассрочки кредитных карт", cells: [.installment(InstalmentListCellViewModel.Seeds.value)]),
                .init(title: "Деньги в рассрочку", cells: [.installment(InstalmentListCellViewModel.Seeds.value)]),
            ]
        )
        static let localizedDescription = "Error 1"
        static let anyObj = UIImage()
        static let amount = Amount.Seeds.model
        static let componentAmount = ComponentAmount(amount: amount)
        static let amountString = Amount.Seeds.descriptionWithoutCurrencySymbol
        static let amountStringWithCurrencySymbol = Amount.Seeds.descriptionWithCurrencySymbol
        static let date = Date(timeIntervalSince1970: 443_785_200)
        static let dateString = "24 января"
        static let instalment = Instalment.Seeds.value
        static let instalmentAmountViewModel = InstalmentAmountViewModel.Seeds.value
        static let cellViewModel = InstalmentListCellViewModel.Seeds.value
        static let url = URL(string: urlString)
        static let urlString = Constants.BaseURL.com.absoluteString
        static let iconView = ImageSource(placeholder: UIImage.assetsCatalog.account_card_image_placeholder)
        static let iconViewWithURL = ImageSource(url: url, placeholder: UIImage.assetsCatalog.account_card_image_placeholder)
        static let errorViewModel = InstalmentList.LoadingError.ViewModel(model: emptyModel, description: errorDescription)
        static let errorDescription = "Error 1"
        static let emptyModel = DefaultEmptyViewModel(
            icon: .init(icon: .image(UIImage.assets.art_telecom_m_black, options: nil)),
            title: L10n.InstalmentList.Error.Network.title,
            subtitle: errorDescription
        )
    }
}
