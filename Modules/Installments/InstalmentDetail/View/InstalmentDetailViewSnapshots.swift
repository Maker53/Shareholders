//  Created by Lyudmila Danilchenko on 25/10/2020.

import ABUIComponents
import SharedProtocolsAndModels
import TestAdditions

@testable import Installments

final class InstalmentDetailViewSnapshots: QuickSpec {
    override func spec() {
        var view: InstalmentDetailView!
        var tableManager: InstalmentDetailTableManager!
        var delegateMock: DisplaysInstalmentDetailViewDelegateMock!

        beforeEach {
            tableManager = .init()
            delegateMock = .init()
            view = .init(delegate: delegateMock)
        }

        describe(".setupHeader") {
            it("should look good") {
                // when
                view.setupHeader(TestData.headerTitle)
                // then
                expect(view).to(beEqualSnapshot("InstalmentDetailView_setupHeader_default"), layout: TestData.layout)
            }
        }

        describe(".init") {
            it("should contain early repayment button") {
                // when
                expect(view).to(beEqualSnapshot("InstalmentDetailView_init"), layout: TestData.layout)
            }
        }

        describe(".configureTableView") {
            it("should be properly configured") {
                // given
                view.setupHeader(TestData.headerTitle)
                tableManager.sections = TestData.sections
                // when
                view.configureTableView(with: tableManager)
                // then
                expect(view).to(
                    beEqualSnapshot("InstalmentDetailView_configureTableView"),
                    layout: TestData.contentLayout
                )
            }
        }
    }
}

// swiftlint:disable non_localized_cyrillic_strings
private extension InstalmentDetailViewSnapshots {
    enum TestData: Theme {
        static let headerTitle = "Header title"
        static let layout: SnapshotLayout = .frameForFullScreen
        static let contentLayout: SnapshotLayout = .frameForFullWidthScreen(height: UIScreen.heightScreen * 1.2)

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
            dataContent: OldDataContentViewModel(title: "Внесите платёж", subtitle: "19 июля"),
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
            backgroundImage: ImageSource.image(UIImage.assetsCatalog.account_card_image_placeholder),
            cardNumber: nil
        )
        static let cells: [DetailInfoSection.Rows] = [
            .amountProgress(amountViewModel),
            .dataViews(termViewModel),
            .dataViews(paymentViewModel),
            .dataViews(lastDateViewModel),
            .dataViews(endDateViewModel),
            .cards(cardViewModel0),
            .cancelBanner(cancelBannerViewModel),
        ]
        static let sections = [
            DetailInfoSection(title: nil, cells: cells),
        ]
        static let cancelBannerViewModel: BannerWrapper.ViewModel = .create(
            from: .style(
                .strokeWithContentInteractions,
                content: .init(
                    backgroundColor: Palette.backgroundPrimary,
                    backgroundColorHighlighted: Palette.backgroundPrimary,
                    borderColor: Palette.borderTertiary
                )
            )
        )
    }
}
