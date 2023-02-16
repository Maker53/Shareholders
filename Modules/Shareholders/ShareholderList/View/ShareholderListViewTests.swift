// Created by Станислав on 07.02.2023.

import TestAdditions
import ABUIComponents
@testable import Shareholders

final class ShareholderListViewTests: QuickSpec {
    override func spec() {
        var view: ShareholderListView!
        var tableViewMock: UITableViewMock!
        var tableManagerMock: ShareholderListTableManagerProtocolMock!
        var delegateMock: ShareholderListViewDelegateMock!
        
        beforeEach {
            tableViewMock = .init()
            tableManagerMock = .init()
            delegateMock = .init()
            view = ShareholderListView(delegate: delegateMock, tableManager: tableManagerMock)
        }
        
        describe(".init") {
            it("should setup tableView") {
                // then
                expect(view.tableView.dataSource).to(beIdenticalTo(tableManagerMock))
                expect(view.tableView.backgroundColor).to(equal(TestData.tableViewBackgroundColor))
            }
        }
        
        describe(".configure") {
            it("should ask table view to reload data") {
                // given
                view.tableView = tableViewMock
                // when
                view.configure(TestData.viewModel)
                // then
                expect(tableViewMock.reloadDataWasCalled).to(beCalledOnce())
            }
        }
    }
}

// MARK: - TestData

private extension ShareholderListViewTests {
    enum TestData: Theme {
        static let viewModel = ShareholderListDataFlow.PresentShareholderList.ViewModel()
        static let tableViewBackgroundColor = Palette.backgroundPrimary
    }
}
