//  Created by Lyudmila Danilchenko on 25/10/2020.

import ABUIComponents
import SharedProtocolsAndModels
import TestAdditions

@testable import Installments

final class InstalmentDetailViewControllerTests: QuickSpec {
    override func spec() {
        var viewController: InstalmentDetailViewController<InstalmentDetailRoutesMock>!
        var analyticsMock: InstalmentDetailEventsMock!
        var contentViewMock: DisplaysInstalmentDetailViewMock!
        var interactorMock: InstalmentDetailBusinessLogicMock!
        var routesMock: InstalmentDetailRoutesMock.Type!
        var tableManagerMock: ManagesInstalmentDetailTableMock!

        beforeEach {
            analyticsMock = InstalmentDetailEventsMock()
            contentViewMock = DisplaysInstalmentDetailViewMock()
            interactorMock = InstalmentDetailBusinessLogicMock()
            routesMock = InstalmentDetailRoutesMock.self
            tableManagerMock = .init()
            viewController = InstalmentDetailViewController(
                analytics: analyticsMock,
                interactor: interactorMock,
                tableManager: tableManagerMock
            )
            viewController.contentView = contentViewMock
        }

        afterEach {
            routesMock.backWasCalled = 0
        }

        describe(".init") {
            it("should init properly") {
                // then
                expect(viewController.analytics).to(beIdenticalTo(analyticsMock))
                expect(viewController.interactor).to(beIdenticalTo(interactorMock))
                expect(viewController.tableManager.delegate).to(beIdenticalTo(viewController))
            }
        }

        describe(".loadView") {
            it("should setup views") {
                // when
                viewController.loadView()
                // then
                expect(viewController.view).to(beIdenticalTo(contentViewMock))
                expect(viewController.tableManager).to(beIdenticalTo(tableManagerMock))
            }
        }

        describe(".viewDidLoad") {
            it("should setup module") {
                // when
                viewController.loadViewIfNeeded()
                // then
                expect(analyticsMock.trackScreenWasCalled).to(beCalledOnce())
                expect(contentViewMock).to(beWaitingState())
                expect(interactorMock.loadDataWasCalled).to(beCalledOnce())
            }
        }

        describe(".displayData") {
            it("should be default state") {
                // when
                viewController.contentView = contentViewMock
                viewController.displayData(TestData.viewModel)
                // then
                expect(contentViewMock).to(beDefaultState())
                expect(tableManagerMock.sections).to(equal(TestData.sections))
                expect(contentViewMock.setupHeaderWasCalled).to(beCalledOnce())
                expect(contentViewMock.reloadTableViewWasCalled).to(beCalledOnce())
                expect(contentViewMock.configureWasCalled).to(beCalledOnce())
                expect(contentViewMock.configureReceivedViewModel).to(equal(TestData.viewModel))
            }
        }

        describe(".didTapRepaymentInfo") {
            it("should call interactor") {
                // when
                viewController.didTapRepaymentInfo()
                // then
                expect(interactorMock.openInfoDialogWasCalled).to(beCalledOnce())
            }
        }

        describe(".infoDialogAction") {
            it("should call interactor") {
                // when
                viewController.infoDialogAction()
                // then
                expect(interactorMock.openTransferWasCalled).to(beCalledOnce())
            }
        }

        describe(".displayTransfer") {
            it("should route to transfer") {
                // when
                viewController.displayTransfer()
                // then
                expect(routesMock.transferSourceDestinationWasCalled).to(beCalledOnce())
                expect(routesMock.transferSourceDestinationReceivedArguments?.destination).to(beNil())
                expect(routesMock.transferSourceDestinationReceivedArguments?.source).to(beNil())
            }
        }

        describe(".displayCancelInstalment") {
            it("should route to cancel") {
                // when
                viewController.displayCancelInstalment(TestData.cancelInstalmentViewModel)
                // then
                expect(routesMock.cancelInstallmentWithWasCalled).to(beCalledOnce())
                expect(routesMock.cancelInstallmentWithReceivedContext).to(equal(TestData.cancelInstallmentContext))
            }
        }

        describe(".didTapCancelBanner") {
            it("should call interactor") {
                // when
                viewController.didTapCancelBanner()
                // then
                expect(interactorMock.openCancelInstallmentWasCalled).to(beCalledOnce())
            }
        }
    }
}

// swiftlint:disable non_localized_cyrillic_strings

private extension InstalmentDetailViewControllerTests {
    enum TestData {
        static let instalment = Instalment.Seeds.value
        static let amountViewModel = InstalmentAmountViewModel.Seeds.value
        static let termViewModel = DataViewModel(
            dataContent: OldDataContentViewModel(title: "Срок", subtitle: "6 месяцев"),
            icon: .init()
        )
        static let paymentViewModel = DataViewModel(
            dataContent: OldDataContentViewModel(title: "Сумма платежа", subtitle: "16 339,82 ₽"),
            icon: .init()
        )
        static let lastDateViewModel = DataViewModel(
            dataContent: OldDataContentViewModel(title: "Внести платёж до", subtitle: "19 июля"),
            icon: .init()
        )
        static let endDateViewModel = DataViewModel(
            dataContent: OldDataContentViewModel(title: "Дата окончания рассрочки", subtitle: "19.07.2017"),
            icon: .init()
        )
        static let cardViewModel0 = CardViewModel(
            title: instalment.account.accountWithCards.cards[0].title,
            value: instalment.account.accountWithCards.cards[0].maskedNumber,
            hasApplePay: false,
            subtitle: L10n.Installments.InstalmentDetail.cardAccountTitle,
            backgroundImage: ImageSource(
                url: URL(string: instalment.account.accountWithCards.cards[0].skinURI ?? .empty),
                placeholder: UIImage.assetsCatalog.account_card_image_placeholder
            ),
            cardNumber: nil
        )
        static let cardViewModel1 = CardViewModel(
            title: instalment.account.accountWithCards.cards[1].title,
            value: instalment.account.accountWithCards.cards[1].maskedNumber,
            hasApplePay: false,
            subtitle: L10n.Installments.InstalmentDetail.cardAccountTitle,
            backgroundImage: ImageSource(
                url: URL(string: instalment.account.accountWithCards.cards[1].skinURI ?? .empty),
                placeholder: UIImage.assetsCatalog.account_card_image_placeholder
            ),
            cardNumber: nil
        )
        static let cardViewModel2 = CardViewModel(
            title: instalment.account.accountWithCards.cards[2].title,
            value: instalment.account.accountWithCards.cards[2].maskedNumber,
            hasApplePay: false,
            subtitle: L10n.Installments.InstalmentDetail.cardAccountTitle,
            backgroundImage: ImageSource(
                url: URL(string: instalment.account.accountWithCards.cards[2].skinURI ?? .empty),
                placeholder: UIImage.assetsCatalog.account_card_image_placeholder
            ),
            cardNumber: nil
        )
        static var cells: [DetailInfoSection.Rows] = [
            .amountProgress(amountViewModel),
            .dataViews(termViewModel),
            .dataViews(paymentViewModel),
            .dataViews(lastDateViewModel),
            .dataViews(endDateViewModel),
            .cards(cardViewModel0),
            .cards(cardViewModel1),
            .cards(cardViewModel2),
        ]
        static let sections: [DetailInfoSection] = [
            DetailInfoSection(title: nil, cells: cells),
        ]
        static let viewModel = InstalmentDetail.PresentModuleData.ViewModel(
            sections: sections,
            shouldEnableRepayment: true,
            shouldHideRepayment: true,
            title: instalment.title
        )
        static let cancelInstallmentContext = CancelInstallmentContext(installment: instalment)
        static let cancelInstalmentViewModel = InstalmentDetail.PresentCancelInstalment.ViewModel(
            cancelInstallmentContext: cancelInstallmentContext
        )
    }
}
