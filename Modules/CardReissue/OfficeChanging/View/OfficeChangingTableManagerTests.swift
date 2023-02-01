//
//  SUT: OfficeChangingTableManager
//
//  Collaborators:
//  UITableView
//  OfficeChangingTableDelegate
//

import ABUIComponents
import TestAdditions

@testable import CardReissue

final class OfficeChangingmanagerTests: QuickSpec {
    override func spec() {
        var manager: OfficeChangingTableManager!
        var tableViewMock: UITableViewMock!
        var delegateMock: OfficeChangingTableDelegateMock!

        beforeEach {
            tableViewMock = UITableViewMock()
            delegateMock = OfficeChangingTableDelegateMock()
            manager = OfficeChangingTableManager(delegate: delegateMock)
        }

        describe(".numberOfRowsInSection") {
            it("should return number of cells") {
                // given
                manager.viewModels = TestData.viewModels
                // when
                let numberOfRows = manager.tableView(tableViewMock, numberOfRowsInSection: 0)
                // then
                expect(numberOfRows).to(equal(TestData.viewModels.count))
            }
        }

        describe(".cellForRowAtIndexPath") {
            context("ArrowCell") {
                beforeEach {
                    manager.viewModels = TestData.viewModels
                    tableViewMock.dequeueReusableCellWithIdentifierStub = PickerCell()
                    tableViewMock.dequeueReusableCellWithIdentifierForIndexPathStub = PickerCell()
                }

                it("should register class with reuseIdentifier") {
                    // given
                    let expectedCellType = PickerCell.self
                    let expectedCellIdentifier = "\(PickerCell.self)"
                    // when
                    _ = manager.tableView(tableViewMock, cellForRowAt: TestData.indexPath)
                    // then
                    let registerCellReceivedArguments = tableViewMock.registerCellClassForCellReuseIdentifierReceivedArguments
                    expect(tableViewMock.registerCellClassForCellReuseIdentifierWasCalled).to(beCalledOnce())
                    expect(registerCellReceivedArguments?.cellClass == expectedCellType).to(beTrue())
                    expect(registerCellReceivedArguments?.identifier).to(equal(expectedCellIdentifier))
                }

                it("should get dequeued cell from table view") {
                    // given
                    let expectedCellIdentifier = "\(PickerCell.self)"

                    // when
                    _ = manager.tableView(tableViewMock, cellForRowAt: TestData.indexPath)

                    // then
                    expect(tableViewMock.dequeueReusableCellWithIdentifierWasCalled).to(beCalledOnce())
                    expect(tableViewMock.dequeueReusableCellWithIdentifierReceivedIdentifier).to(equal(expectedCellIdentifier))
                }
            }
        }

        describe(".didSelectRowAtIndexPath") {
            beforeEach {
                manager.viewModels = TestData.viewModels
            }

            it("should call delegate method") {
                // given
                let indexPath = TestData.indexPath
                // when
                manager.tableView(tableViewMock, didSelectRowAt: indexPath)
                // then
                expect(tableViewMock.deselectRowWasCalled).to(beCalledOnce())
                expect(tableViewMock.deselectRowReceivedArguments?.indexPath).to(equal(indexPath))
                expect(tableViewMock.deselectRowReceivedArguments?.animated).to(equal(true))
                expect(delegateMock.didSelectRowWasCalled).to(beCalledOnce())
                expect(delegateMock.didSelectRowArgument).to(equal(.city))
            }
        }
    }
}

private extension OfficeChangingmanagerTests {
    enum TestData {
        static let indexPath = IndexPath(row: 0, section: 0)
        static let viewModel = OfficeChangingViewModel(
            pickerViewModel: PickerCellViewModel(
                title: "City",
                value: "Moscow"
            ),
            row: .city
        )
        static let viewModels = Array(repeating: viewModel, count: 3)
    }
}

private final class OfficeChangingTableDelegateMock: OfficeChangingTableDelegate {
    var didSelectRowWasCalled = 0
    var didSelectRowArgument: OfficeChangingRowType?
    func didSelectRow(_ row: OfficeChangingRowType) {
        didSelectRowWasCalled += 1
        didSelectRowArgument = row
    }
}
