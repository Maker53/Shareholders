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
        
        describe(".configure") {
            it("should ask table view to reload data") {
                // given
                view.tableView = tableViewMock
                // when
                view.configure(.init())
                // then
                expect(tableViewMock.reloadDataWasCalled).to(beCalledOnce())
            }
        }
    }
}
