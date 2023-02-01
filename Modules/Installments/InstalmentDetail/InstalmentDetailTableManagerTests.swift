//  Created by Lyudmila Danilchenko on 11.09.2020.

import ABUIComponents
import SharedProtocolsAndModels
import TestAdditions

@testable import Installments

final class InstalmentDetailTableManagerTests: QuickSpec {
    override func spec() {
        var tableManager: ManagesInstalmentDetailTable!
        var tableViewMock: UITableViewMock!
        var delegateMock: InstalmentDetailTableManagerDelegateMock!

        beforeEach {
            tableManager = InstalmentDetailTableManager()
            tableViewMock = UITableViewMock()
            tableManager.sections = TestData.sections

            tableViewMock.numberOfSectionsStub = 1
            tableViewMock.dataSource = tableManager
            tableViewMock.delegate = tableManager

            delegateMock = .init()
            tableManager.delegate = delegateMock
        }

        describe(".notification received") {
            it("should call delegate") {
                // when
                NotificationCenter.default.post(name: InstalmentDetail.cancelNotificationName, object: nil)
                // then
                expect(delegateMock.didTapCancelBannerWasCalled).to(beCalledOnce())
            }
        }

        describe(".didSelectRowAt") {
            context("when repayment info row selected") {
                it("should call delegate") {
                    // given
                    tableManager.sections = TestData.sections
                    // when
                    let indexPath = TestData.RightIcon.indexPath
                    tableManager.tableView?(tableViewMock, didSelectRowAt: indexPath)
                    // then
                    expect(delegateMock.didTapRepaymentInfoWasCalled)
                        .to(beCalledOnce())
                    expect(tableViewMock.deselectRowWasCalled).to(beCalledOnce())
                    expect(tableViewMock.deselectRowReceivedArguments?.indexPath).to(equal(indexPath))
                    expect(tableViewMock.deselectRowReceivedArguments?.animated).to(equal(TestData.deselectAnimatedArgument))
                }
            }

            context("when row is not right icon data view") {
                it("should not call delegate") {
                    // given
                    tableManager.sections = [DetailInfoSection(title: nil, cells: TestData.otherCells)]
                    // when
                    let indexPath = TestData.RightIcon.indexPath
                    tableManager.tableView?(tableViewMock, didSelectRowAt: indexPath)
                    // then
                    expect(delegateMock.didTapRepaymentInfoWasCalled)
                        .toNot(beCalled())
                    expect(tableViewMock.deselectRowWasCalled).to(beCalledOnce())
                    expect(tableViewMock.deselectRowReceivedArguments?.indexPath).to(equal(indexPath))
                    expect(tableViewMock.deselectRowReceivedArguments?.animated).to(equal(TestData.deselectAnimatedArgument))
                }
            }

            context("when there is no row") {
                it("should not call delegate") {
                    // given
                    tableManager.sections = [DetailInfoSection(title: nil, cells: [])]
                    // when
                    let indexPath = TestData.RightIcon.indexPath
                    tableManager.tableView?(tableViewMock, didSelectRowAt: indexPath)
                    // then
                    expect(delegateMock.didTapRepaymentInfoWasCalled)
                        .toNot(beCalled())
                    expect(tableViewMock.deselectRowWasCalled).to(beCalledOnce())
                    expect(tableViewMock.deselectRowReceivedArguments?.indexPath).to(equal(indexPath))
                    expect(tableViewMock.deselectRowReceivedArguments?.animated).to(equal(TestData.deselectAnimatedArgument))
                }
            }
        }

        describe(".numberOfSections") {
            it("should return number of sections from view model") {
                // given
                tableManager.sections = TestData.sections
                // when
                let numberOfSections = tableManager.numberOfSections?(in: tableViewMock)
                // then
                expect(numberOfSections).to(equal(TestData.sections.count))
            }
        }

        describe(".numberOfRowsInSection") {
            it("should return correct number of cells") {
                // when
                let numberOfRows = tableManager.tableView(tableViewMock, numberOfRowsInSection: 0)
                // then
                expect(numberOfRows).to(equal(TestData.sections[0].cells.count))
            }

            it("should return 0") {
                // given
                tableManager.sections = TestData.sections

                // when
                let numberOfRows = tableManager.tableView(tableViewMock, numberOfRowsInSection: TestData.incorrectSection)
                // then
                expect(numberOfRows).to(equal(0))
            }
        }

        describe(".cellForRowAtIndexPath") {
            it("should get correct cell type amountProgress") {
                // given
                tableViewMock.dequeueReusableCellWithIdentifierStub =
                    TestData.Amount.cell
                tableViewMock.dequeueReusableCellWithIdentifierForIndexPathStub = TestData.Amount.cell

                // when
                let cell = tableManager.tableView(tableViewMock, cellForRowAt: TestData.Amount.indexPath)

                // then
                expect(tableViewMock.dequeueReusableCellWithIdentifierReceivedIdentifier)
                    .to(equal(TestData.Amount.cellID))
                expect(cell).to(beAnInstanceOf(TestData.Amount.type))
            }

            it("should get correct cell type DataView") {
                // given
                tableViewMock.dequeueReusableCellWithIdentifierStub =
                    TestData.Data.cell
                tableViewMock.dequeueReusableCellWithIdentifierForIndexPathStub = TestData.Data.cell

                // when
                let cell = tableManager.tableView(tableViewMock, cellForRowAt: TestData.Data.indexPath)

                // then
                expect(tableViewMock.dequeueReusableCellWithIdentifierReceivedIdentifier)
                    .to(equal(TestData.Data.cellID))
                expect(cell).to(beAnInstanceOf(TestData.Data.type))
            }

            it("should get correct cell type CardView") {
                // given
                tableViewMock.dequeueReusableCellWithIdentifierStub =
                    TestData.Cards.cell
                tableViewMock.dequeueReusableCellWithIdentifierForIndexPathStub = TestData.Cards.cell

                // when
                let cell = tableManager.tableView(tableViewMock, cellForRowAt: TestData.Cards.indexPath)

                // then
                expect(tableViewMock.dequeueReusableCellWithIdentifierReceivedIdentifier)
                    .to(equal(TestData.Cards.cellID))
                expect(cell).to(beAnInstanceOf(TestData.Cards.type))
            }

            it("should return UITablewViewCell") {
                // when
                let cell = tableManager.tableView(tableViewMock, cellForRowAt: TestData.incorrectIndexPath)
                // then
                expect(cell).to(beAnInstanceOf(UITableViewCell.self))
            }

            it("should return separator") {
                // given
                tableViewMock.dequeueReusableCellWithIdentifierStub = TestData.Separator.cell
                tableViewMock.dequeueReusableCellWithIdentifierForIndexPathStub = TestData.Separator.cell
                // when
                let cell = tableManager.tableView(tableViewMock, cellForRowAt: TestData.Separator.indexPath)
                // then
                expect(cell).to(beAnInstanceOf(TestData.Separator.CellType.self))
            }

            it("should return banner cell") {
                // given
                tableViewMock.dequeueReusableCellWithIdentifierStub = TestData.Banner.cell
                tableViewMock.dequeueReusableCellWithIdentifierForIndexPathStub = TestData.Banner.cell
                // when
                let cell = tableManager.tableView(tableViewMock, cellForRowAt: TestData.Banner.indexPath)
                // then
                expect(cell).to(beAnInstanceOf(TestData.Banner.CellType.self))
            }

            it("should return cancel banner cell") {
                // given
                tableViewMock.dequeueReusableCellWithIdentifierStub = TestData.CancelBanner.cell
                tableViewMock.dequeueReusableCellWithIdentifierForIndexPathStub = TestData.CancelBanner.cell
                tableManager.sections = TestData.sectionsWithCancel
                // when
                let cell = tableManager.tableView(tableViewMock, cellForRowAt: TestData.CancelBanner.indexPath)
                // then
                expect(cell).to(beAnInstanceOf(TestData.CancelBanner.CellType.self))
                expect(cell.selectionStyle).to(equal(UITableViewCell.SelectionStyle.none))
            }

            it("should return right icon cell") {
                // given
                tableViewMock.dequeueReusableCellWithIdentifierStub = TestData.RightIcon.cell
                tableViewMock.dequeueReusableCellWithIdentifierForIndexPathStub = TestData.RightIcon.cell
                // when
                let cell = tableManager.tableView(tableViewMock, cellForRowAt: TestData.RightIcon.indexPath)
                // then
                expect(cell).to(beAnInstanceOf(TestData.RightIcon.CellType.self))
            }
        }
    }
}

// swiftlint:disable non_localized_cyrillic_strings nesting

private extension InstalmentDetailTableManagerTests {
    enum TestData {
        enum Separator {
            typealias CellType = GenericTableCell<SeparatorView>

            static let indexPath = IndexPath(row: 8, section: 0)
            static let cell = CellType()
        }

        enum Banner {
            typealias CellType = BannerTextViewCell<BannerTextViewStyle.Warning>

            static let indexPath = IndexPath(row: 9, section: 0)
            static let cell = CellType()
        }

        enum RightIcon {
            typealias CellType = GenericTableCell<
                OldRightIconWrapper<
                    OldDataView<IconViewStyle.NoIcon, DataContentStyle.Default>,
                    InstalmentDetailPopUpViewModel,
                    RightIconWrapperStyle.Default,
                    IconViewStyle.Icon
                >
            >

            static let cell = CellType()
            static let indexPath = IndexPath(row: 10, section: 0)
        }

        typealias NoIconStyle = OldDataView<IconViewStyle.NoIcon, DataContentStyle.Revert>

        enum Amount {
            static let cellID = "\(GenericTableCell<AmountProgressView>.self)"
            static let type = GenericTableCell<AmountProgressView>.self
            static let cell = GenericTableCell<AmountProgressView>()
            static let indexPath = IndexPath(row: 0, section: 0)
        }

        enum Data {
            static let cellID = "\(GenericTableCell<NoIconStyle>.self)"
            static let type = GenericTableCell<NoIconStyle>.self
            static let cell = GenericTableCell<NoIconStyle>()
            static let indexPath = IndexPath(row: 1, section: 0)
        }

        enum Cards {
            static let cellID = "\(CardViewCell<CardViewStyle.RightMeduimExtended, CardIconViewStyle.Small, CardContentStyle.Revert>.self)"
            static let type = CardViewCell<CardViewStyle.RightMeduimExtended, CardIconViewStyle.Small, CardContentStyle.Revert>.self
            static let cell = CardViewCell<CardViewStyle.RightMeduimExtended, CardIconViewStyle.Small, CardContentStyle.Revert>.self()
            static let indexPath = IndexPath(row: 5, section: 0)
        }

        enum CancelBanner {
            typealias CellType = GenericTableCell<BannerWrapper>

            static let indexPath = IndexPath(row: 8, section: 0)
            static let cell = CellType()
        }

        static let deselectAnimatedArgument = false
        static let incorrectSection = 66
        static let incorrectIndexPath = IndexPath(row: Int.max, section: 0)
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
        static let cancelBannerVM: BannerWrapper.ViewModel = .create(
            from: .style(
                .strokeWithContentInteractions,
                content: .init(
                    backgroundColor: appearance.palette.backgroundPrimary,
                    backgroundColorHighlighted: appearance.palette.backgroundPrimary,
                    borderColor: appearance.palette.borderTertiary
                )
            )
        )
        static let bannerVM = BannerTextViewModel(title: "123", subtitle: "123")
        static var cells: [DetailInfoSection.Rows] = [
            .amountProgress(amountViewModel),
            .dataViews(termViewModel),
            .dataViews(paymentViewModel),
            .dataViews(lastDateViewModel),
            .dataViews(endDateViewModel),
            .cards(cardViewModel0),
            .cards(cardViewModel1),
            .cards(cardViewModel2),
            .separator,
            .banner(bannerVM),
            .rightIconDataView(InstalmentDetailPopUpViewModel(title: "123", rightIcon: .init())),
        ]
        static var otherCells: [DetailInfoSection.Rows] = [
            .amountProgress(amountViewModel),
            .dataViews(termViewModel),
            .dataViews(paymentViewModel),
            .dataViews(lastDateViewModel),
            .dataViews(endDateViewModel),
            .cards(cardViewModel0),
            .cards(cardViewModel1),
            .cards(cardViewModel2),
            .separator,
            .banner(bannerVM),
            .separator,
        ]
        static var cellsWithCancel: [DetailInfoSection.Rows] = [
            .amountProgress(amountViewModel),
            .dataViews(termViewModel),
            .dataViews(paymentViewModel),
            .dataViews(lastDateViewModel),
            .dataViews(endDateViewModel),
            .cards(cardViewModel0),
            .cards(cardViewModel1),
            .cards(cardViewModel2),
            .cancelBanner(cancelBannerVM),
        ]
        static let sections: [DetailInfoSection] = [
            DetailInfoSection(title: nil, cells: cells),
        ]
        static let sectionsWithCancel: [DetailInfoSection] = [
            DetailInfoSection(title: nil, cells: cellsWithCancel),
        ]

        static let appearance = Appearance(); struct Appearance: Theme { }
    }
}
