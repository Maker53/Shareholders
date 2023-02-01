import ABUIComponents
import TestAdditions

@testable import Installments

final class CancelInstallmentTableManagerTests: QuickSpec {
    override func spec() {
        var manager: CancelInstallmentTableManager!
        var tableViewMock: UITableViewMock!
        var delegateMock: CancelInstallmentTableManagerDelegateMock!

        beforeEach {
            delegateMock = .init()
            tableViewMock = .init()
            manager = .init()
            manager.delegate = delegateMock
        }

        describe(".numberOfSections") {
            it("should return correct value") {
                // given
                manager.sections = TestData.dummySections
                // then
                expect(manager.numberOfSections(in: tableViewMock)).to(equal(TestData.dummySections.count))
            }
        }

        describe(".numberOfRowsInSection") {
            it("should return correct value") {
                // given
                manager.sections = TestData.dummySections
                // then
                expect(manager.tableView(tableViewMock, numberOfRowsInSection: 0)).to(equal(0))
                expect(manager.tableView(tableViewMock, numberOfRowsInSection: 1)).to(equal(0))
                expect(manager.tableView(tableViewMock, numberOfRowsInSection: 2)).to(equal(0))
            }
        }

        describe(".cellForRowAt") {
            it("should return correct value") {
                // when
                let cell = manager.tableView(tableViewMock, cellForRowAt: .init(row: 999, section: 999))
                // then
                expect(cell).to(beAnInstanceOf(UITableViewCell.self))
            }

            it("should return correct cell ComissionRefund") {
                // given
                tableViewMock.dequeueReusableCellWithIdentifierStub = TestData.ComissionRefund.cell
                tableViewMock.dequeueReusableCellWithIdentifierForIndexPathStub = TestData.ComissionRefund.cell
                manager.sections = TestData.ComissionRefund.sections
                // when
                let cell = manager.tableView(tableViewMock, cellForRowAt: TestData.ComissionRefund.indexPath)
                // then
                expect(cell).to(beAnInstanceOf(TestData.ComissionRefund.CellType.self))
                expect(cell.selectionStyle).to(equal(UITableViewCell.SelectionStyle.none))
            }

            it("should return correct cell TextView") {
                // given
                tableViewMock.dequeueReusableCellWithIdentifierStub = TestData.TextView.cell
                tableViewMock.dequeueReusableCellWithIdentifierForIndexPathStub = TestData.TextView.cell
                manager.sections = TestData.TextView.sections
                // when
                let cell = manager.tableView(tableViewMock, cellForRowAt: TestData.TextView.indexPath)
                // then
                expect(cell).to(beAnInstanceOf(TestData.TextView.CellType.self))
                expect(cell.selectionStyle).to(equal(UITableViewCell.SelectionStyle.none))
            }

            it("should return correct cell RedText") {
                // given
                tableViewMock.dequeueReusableCellWithIdentifierStub = TestData.RedText.cell
                tableViewMock.dequeueReusableCellWithIdentifierForIndexPathStub = TestData.RedText.cell
                manager.sections = TestData.RedText.sections
                // when
                let cell = manager.tableView(tableViewMock, cellForRowAt: TestData.RedText.indexPath)
                // then
                expect(cell).to(beAnInstanceOf(TestData.RedText.CellType.self))
                expect(cell.selectionStyle).to(equal(UITableViewCell.SelectionStyle.none))
            }

            it("should return correct cell Input") {
                // given
                tableViewMock.dequeueReusableCellWithIdentifierStub = TestData.Input.cell
                tableViewMock.dequeueReusableCellWithIdentifierForIndexPathStub = TestData.Input.cell
                manager.sections = TestData.Input.sections
                // when
                let cell = manager.tableView(tableViewMock, cellForRowAt: TestData.Input.indexPath) as? TestData.Input.CellType
                // then
                expect(cell).toNot(beNil())
                expect(cell?.cellView.delegate).to(beIdenticalTo(manager))
                expect(cell?.selectionStyle).to(equal(UITableViewCell.SelectionStyle.none))
            }

            it("should return correct cell Documents") {
                // given
                tableViewMock.dequeueReusableCellWithIdentifierStub = TestData.Documents.cell
                tableViewMock.dequeueReusableCellWithIdentifierForIndexPathStub = TestData.Documents.cell
                manager.sections = TestData.Documents.sections
                // when
                let cell = manager.tableView(tableViewMock, cellForRowAt: TestData.Documents.indexPath)
                // then
                expect(cell).to(beAnInstanceOf(TestData.Documents.CellType.self))
                expect(cell.selectionStyle).to(equal(UITableViewCell.SelectionStyle.none))
            }
        }

        describe(".heightForHeaderInSection") {
            context("when there is a title") {
                it("should return correct value") {
                    // given
                    manager.sections = TestData.dummySectionsWithHeader
                    // when
                    let value = manager.tableView(tableViewMock, heightForHeaderInSection: 0)
                    // then
                    expect(value).to(equal(52))
                }
            }
            context("when there is no title") {
                it("should return correct value") {
                    // given
                    manager.sections = TestData.dummySectionsWithHeader
                    // when
                    let value = manager.tableView(tableViewMock, heightForHeaderInSection: 1)
                    // then
                    expect(value).to(equal(0))
                }
            }
        }

        describe(".viewForHeaderInSection") {
            context("when there is no title") {
                it("should return nil") {
                    // given
                    manager.sections = TestData.dummySectionsWithHeader
                    // when
                    let view = manager.tableView(tableViewMock, viewForHeaderInSection: 1)
                    // then
                    expect(tableViewMock.dequeueReusableHeaderFooterViewWasCalled).toNot(beCalled())
                    expect(view).to(beNil())
                }
            }

            context("when there is a title") {
                it("should return correct view") {
                    // given
                    manager.sections = TestData.dummySectionsWithHeader
                    tableViewMock.dequeueReusableHeaderFooterViewStub = TestData.Header.view
                    // when
                    let view = manager.tableView(tableViewMock, viewForHeaderInSection: 0)
                    // then
                    expect(tableViewMock.dequeueReusableHeaderFooterViewWasCalled)
                        .to(beCalledOnce())
                    expect(tableViewMock.dequeueReusableHeaderFooterReceiveIdentifier)
                        .to(equal(TestData.Header.viewID))
                    expect(view).to(beIdenticalTo(TestData.Header.view))
                }
            }
        }

        describe(".textFieldDidEndEditing") {
            it("should call delegate's method") {
                // given
                let textField = UITextField()
                textField.text = "text"
                // when
                manager.textFieldDidEndEditing(textField)
                // then
                expect(delegateMock.textFieldDidEndEditingWasCalled).to(beCalledOnce())
                expect(delegateMock.textFieldDidEndEditingReceivedText)
                    .to(equal(textField.text))
            }
        }

        describe(".didSelectRowAt") {
            context("with correct indexPath") {
                it("should call delegate") {
                    // given
                    manager.sections = TestData.Documents.sections
                    // when
                    manager.tableView(tableViewMock, didSelectRowAt: TestData.Documents.indexPath)
                    // then
                    expect(tableViewMock.deselectRowWasCalled).to(beCalledOnce())
                    expect(delegateMock.didSelectDocumentWasCalled).to(beCalledOnce())
                    expect(tableViewMock.deselectRowReceivedArguments?.indexPath)
                        .to(equal(TestData.Documents.indexPath))
                }
            }
            context("with incorrect indexPath") {
                it("should not call delegate") {
                    // given
                    manager.sections = TestData.Documents.sections
                    // when
                    manager.tableView(tableViewMock, didSelectRowAt: TestData.Documents.incorrectIndexPath)
                    // then
                    expect(delegateMock.didSelectDocumentWasCalled).toNot(beCalled())
                    expect(tableViewMock.deselectRowWasCalled).to(beCalledOnce())
                }
            }
            context("with not .document indexPath") {
                it("should not call delegate") {
                    // given
                    manager.sections = TestData.Documents.sections
                    // when
                    manager.tableView(tableViewMock, didSelectRowAt: TestData.Documents.indexPathRow1)
                    // then
                    expect(delegateMock.didSelectDocumentWasCalled).toNot(beCalled())
                    expect(tableViewMock.deselectRowWasCalled).to(beCalledOnce())
                }
            }
        }
    }
}

// swiftlint:disable nesting
extension CancelInstallmentTableManagerTests {
    enum TestData {
        enum Input {
            typealias CellType = GenericTableCell<TextField>

            static let viewModel = InstallmentsTextFieldViewModel(
                errorMessage: nil,
                formatter: CommonTextFieldFormatter(),
                hint: nil,
                keyboardType: .emailAddress,
                placeholder: nil,
                title: nil
            )
            static let sections = [
                CancelInstallmentSection(header: nil, rows: [.input(viewModel)]),
            ]
            static let indexPath = IndexPath(row: 0, section: 0)
            static let cell = CellType()
        }

        enum ComissionRefund {
            typealias CellType = GenericTableCell<
                CancelInstallmentTableManager.ComissionRefundView
            >

            static let viewModel = DataViewModel(dataContent: .init(title: .empty), icon: .init())
            static let sections: [CancelInstallmentSection] = [
                .init(header: nil, rows: [.comissionRefund(viewModel)]),
            ]
            static let indexPath = IndexPath(row: 0, section: 0)
            static let cell = CellType()
        }

        enum TextView {
            typealias CellType = GenericTableCell<
                CancelInstallmentTableManager.TextCellView
            >

            static let sections: [CancelInstallmentSection] = [
                .init(header: nil, rows: [.textView(CancelInstallment.Seeds.textViewRowViewModel)]),
            ]
            static let indexPath = IndexPath(row: 0, section: 0)
            static let cell = CellType()
        }

        enum RedText {
            typealias CellType = GenericTableCell<
                CancelInstallmentTableManager.RedTextView
            >

            static let viewModel = DataViewModel(dataContent: .init(title: "title"), icon: .init())
            static let sections: [CancelInstallmentSection] = [
                .init(header: nil, rows: [.redText(viewModel)]),
            ]
            static let indexPath = IndexPath(row: 0, section: 0)
            static let cell = CellType()
        }

        enum Documents {
            typealias CellType = GenericTableCell<
                OldDataView<IconViewStyle.SmallIcon, DataContentStyle.Default>
            >

            static let viewModel = DataViewModel(dataContent: .init(title: "title"), icon: .init())
            static let sections: [CancelInstallmentSection] = [
                .init(header: "header", rows: [.document(viewModel)]),
                .init(header: nil, rows: [.redText(viewModel)]),
            ]
            static let indexPath = IndexPath(row: 0, section: 0)
            static let indexPathRow1 = IndexPath(row: 1, section: 0)
            static let incorrectIndexPath = IndexPath(row: 999, section: 9)
            static let cell = CellType()
        }

        enum Header {
            static let viewType = TableHeaderFooterTextView<TextViewStyle.Custom.Left<LabelStyle.HeadlineXSmall>>.self
            static let view = viewType.init()
            static let viewID = "\(viewType)"
        }

        struct Appearance: Theme, Grid {
            var heightForHeaderInSection: CGFloat { xxxsSpace * 13 }

            var docsHeaderInsets: UIEdgeInsets {
                UIEdgeInsets(top: xxxsSpace + mSpace, left: mSpace, bottom: xsSpace, right: mSpace)
            }
        }

        static let dummySections: [CancelInstallmentSection] = [
            .init(header: nil, rows: []),
            .init(header: nil, rows: []),
        ]
        static let dummySectionsWithHeader: [CancelInstallmentSection] = [
            .init(header: "header", rows: []),
            .init(header: nil, rows: []),
        ]
        static let appearance = Appearance()
    }
}
