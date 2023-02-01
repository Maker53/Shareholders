//
//  SUT: OfficeChangingPickerDataSource
//

import ABUIComponents
import TestAdditions

@testable import CardReissue

final class OfficeChangingPickerDataSourceTests: QuickSpec {
    override func spec() {
        var dataSource: OfficeChangingPickerDataSource!
        var handlerMock: SelectionHandlerMock!
        var pickerMock: ScrollablePickerViewController!
        var tableViewMock: UITableViewMock!

        beforeEach {
            tableViewMock = UITableViewMock()
            pickerMock = ScrollablePickerViewController(dataSource: ScrollablePickerViewControllerDataSourceMock())
            handlerMock = SelectionHandlerMock()
            dataSource = OfficeChangingPickerDataSource(
                viewModels: TestData.viewModels,
                selectionHandler: handlerMock.select
            )
        }

        describe(".didSelectItemAt") {
            it("should call selection handler") {
                // when
                dataSource.scrollablePicker(pickerMock, didSelectItemAt: TestData.indexPath)
                // then
                expect(handlerMock.selectWasCalled).to(beCalledOnce())
                expect(handlerMock.selectArguments).to(equal(TestData.indexPath.row))
            }
        }

        describe(".scrollablePickerItemsCount") {
            it("should return items count") {
                expect(dataSource.scrollablePickerItemsCount(pickerMock)).to(equal(TestData.viewModels.count))
            }
        }

        describe(".cellForItemAt") {
            it("should register, deque and return GenericTableCell with SimpleTextCellView") {
                // given
                tableViewMock.dequeueReusableCellWithIdentifierStub = ActionCell()
                let expectedType = ActionCell.self
                // when
                let cell = dataSource.scrollablePicker(pickerMock, tableView: tableViewMock, cellForItemAt: TestData.indexPath)
                // then
                let registerCellReceivedArguments = tableViewMock.registerCellClassForCellReuseIdentifierReceivedArguments
                expect(tableViewMock.registerCellClassForCellReuseIdentifierWasCalled).to(beCalledOnce())
                expect(registerCellReceivedArguments?.cellClass).to(beIdenticalTo(expectedType))
                expect(registerCellReceivedArguments?.identifier).to(equal(defaultReuseID(of: expectedType)))
                expect(tableViewMock.dequeueReusableCellWithIdentifierWasCalled).to(beCalledOnce())
                expect(tableViewMock.dequeueReusableCellWithIdentifierReceivedIdentifier).to(equal(defaultReuseID(of: expectedType)))
                expect(cell).to(beAKindOf(expectedType))
            }
        }
    }
}

private extension OfficeChangingPickerDataSourceTests {
    enum TestData {
        static let pickerViewModel = PickerCellViewModel(title: "title", value: "value")
        static let viewModels: [OfficeChangingCellViewModel] = [
            OfficeChangingCellViewModel(title: "first"),
            OfficeChangingCellViewModel(title: "second"),
        ]
        static let indexPath = IndexPath(row: 1, section: 0)
    }
}

private final class SelectionHandlerMock {
    var selectWasCalled = 0
    var selectArguments: Int?

    func select(_ index: Int) {
        selectWasCalled += 1
        selectArguments = index
    }
}
