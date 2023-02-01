//  Created by Lyudmila Danilchenko on 23.09.2020.

import ABUIComponents
import TestAdditions
@testable import Installments

final class InstalmentListTableManagerTests: QuickSpec {
    override func spec() {
        var tableManager: ManagesInstalmentListTable!
        var tableViewMock: UITableViewMock!
        var delegateMock: InstalmentListTableManagerDelegateMock!

        beforeEach {
            tableManager = InstalmentListTableManager()
            tableViewMock = UITableViewMock()
            delegateMock = .init()
            tableManager.delegate = delegateMock
            tableManager.sections = TestData.sections
        }

        describe(".numberOfSections") {
            it("should return correct value") {
                // then
                expect(tableManager.numberOfSections?(in: tableViewMock)).to(equal(TestData.sections.count))
            }
        }

        describe(".numberOfRowsInSection") {
            it("should return correct number of cells") {
                for (index, section) in TestData.sections.enumerated() {
                    expect(tableManager.tableView(tableViewMock, numberOfRowsInSection: index)).to(equal(section.cells.count))
                }
            }
        }

        describe(".cellForRowAtIndexPath") {
            beforeEach {
                tableViewMock.dequeueReusableCellWithIdentifierStub = InstalmentListCell()
                tableViewMock.dequeueReusableCellWithIdentifierForIndexPathStub = InstalmentListCell()
            }

            it("should get correct cell type") {
                // given
                let expectedCellIdentifier = "\(InstalmentListCell.self)"

                // when
                let cell = tableManager.tableView(tableViewMock, cellForRowAt: TestData.indexPath)

                // then
                expect(tableViewMock.dequeueReusableCellWithIdentifierReceivedIdentifier).to(equal(expectedCellIdentifier))
                expect(cell).to(beAnInstanceOf(InstalmentListCell.self))
            }

            it("should get correct cell type") {
                // given
                tableViewMock.dequeueReusableCellWithIdentifierStub = TestData.PaymentCellType()
                tableViewMock.dequeueReusableCellWithIdentifierForIndexPathStub = TestData.PaymentCellType()
                let expectedCellIdentifier = "\(TestData.PaymentCellType.self)"

                // when
                let cell = tableManager.tableView(tableViewMock, cellForRowAt: TestData.paymentCellIndexPath)

                // then
                expect(tableViewMock.dequeueReusableCellWithIdentifierReceivedIdentifier).to(equal(expectedCellIdentifier))
                expect(cell).to(beAnInstanceOf(TestData.PaymentCellType.self))
            }

            it("should get correct cell type") {
                // given
                let expectedCellIdentifier = "\(InstalmentListCell.self)"

                // when
                let cell = tableManager.tableView(tableViewMock, cellForRowAt: TestData.debitInstallmentIndexPath)

                // then
                expect(tableViewMock.dequeueReusableCellWithIdentifierReceivedIdentifier).to(equal(expectedCellIdentifier))
                expect(cell).to(beAnInstanceOf(InstalmentListCell.self))
            }

            it("should return UITablewViewCell") {
                // when
                let cell = tableManager.tableView(tableViewMock, cellForRowAt: TestData.incorrectIndexPath)
                // then
                expect(cell).to(beAnInstanceOf(UITableViewCell.self))
            }
        }

        describe(".didSelectRowAt") {
            it("should call delegate") {
                // when
                tableManager.tableView?(tableViewMock, didSelectRowAt: TestData.indexPath)
                // then
                expect(delegateMock.didSelectInstalmentTypeWasCalled).to(beCalledOnce())
                expect(delegateMock.didSelectInstalmentTypeReceivedArguments?.instalment)
                    .to(equal(TestData.viewModel.instalment))
                expect(delegateMock.didSelectInstalmentTypeReceivedArguments?.type)
                    .to(equal(.credit))
                expect(tableViewMock.deselectRowWasCalled).to(beCalledOnce())
                expect(tableViewMock.deselectRowReceivedArguments?.indexPath)
                    .to(equal(TestData.indexPath))
            }

            it("should not call delegate") {
                // when
                tableManager.tableView?(tableViewMock, didSelectRowAt: TestData.incorrectIndexPath)
                // then
                expect(delegateMock.didSelectInstalmentTypeWasCalled).toNot(beCalled())
                expect(tableViewMock.deselectRowWasCalled).to(beCalledOnce())
            }

            context("when debit installment cell") {
                it("should call delegate") {
                    // when
                    tableManager.tableView?(tableViewMock, didSelectRowAt: TestData.debitInstallmentIndexPath)
                    // then
                    expect(delegateMock.didSelectInstalmentTypeWasCalled).to(beCalledOnce())
                    expect(delegateMock.didSelectInstalmentTypeReceivedArguments?.instalment)
                        .to(equal(TestData.viewModel.instalment))
                    expect(delegateMock.didSelectInstalmentTypeReceivedArguments?.type)
                        .to(equal(.debit))
                    expect(tableViewMock.deselectRowWasCalled).to(beCalledOnce())
                    expect(tableViewMock.deselectRowReceivedArguments?.indexPath)
                        .to(equal(TestData.debitInstallmentIndexPath))
                }
            }
        }

        describe(".viewForHeaderInSection") {
            context("when title and section is ok") {
                it("should return corerct view") {
                    // given
                    tableViewMock.dequeueReusableHeaderFooterViewStub = TableSectionHeaderView<HeaderViewStyle.Heading4>()
                    // when
                    let view = tableManager.tableView?(tableViewMock, viewForHeaderInSection: 0)
                    // then
                    expect(view).to(beAnInstanceOf(TableSectionHeaderView<HeaderViewStyle.Heading4>.self))
                }
            }
            context("when section is wrong") {
                it("should return nil") {
                    // given
                    tableViewMock.dequeueReusableHeaderFooterViewStub = TableSectionHeaderView<HeaderViewStyle.Heading4>()
                    // when
                    let view = tableManager.tableView?(tableViewMock, viewForHeaderInSection: 99)
                        as? TableSectionHeaderView<HeaderViewStyle.Heading4>
                    // then
                    expect(view).to(beNil())
                }
            }
            context("when there is no title") {
                it("should return nil") {
                    // given
                    tableViewMock.dequeueReusableHeaderFooterViewStub = TableSectionHeaderView<HeaderViewStyle.Heading4>()
                    // when
                    let view = tableManager.tableView?(tableViewMock, viewForHeaderInSection: 2)
                        as? TableSectionHeaderView<HeaderViewStyle.Heading4>
                    // then
                    expect(view).to(beNil())
                }
            }
        }
    }
}

private extension InstalmentListTableManagerTests {
    enum TestData {
        typealias PaymentCellType = GenericTableCell<OldDataView<IconViewStyle.NoIcon, DataContentStyle.Revert>>

        static let indexPath = IndexPath(row: 0, section: 0)
        static let sections: [InstallmentListSection] = [
            .init(title: "Section 1", cells: [.installment(viewModel), .installment(viewModel)]),
            .init(title: "Section 2", cells: [.installment(viewModel), .installment(viewModel)]),
            .init(title: nil, cells: [.installment(viewModel), .installment(viewModel)]),
            .init(title: nil, cells: [.amount(amountViewModel)]),
            .init(title: nil, cells: [.debitInstallment(viewModel)]),
        ]
        static let amountViewModel = DataViewModel(
            dataContent: .init(title: "1234"),
            icon: .init()
        )
        static let paymentCellIndexPath = IndexPath(row: 0, section: 3)
        static let viewModel = InstalmentListCellViewModel.Seeds.value
        static let incorrectIndexPath = IndexPath(row: Int.max, section: 0)
        static let debitInstallmentIndexPath = IndexPath(row: 0, section: 4)
    }
}
