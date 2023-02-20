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
            view = .init(delegate: delegateMock)
        }
        
        describe(".init") {
            it("should init table manager") {
                // then
                expect(view.tableManager).to(beAnInstanceOf(TestData.PresentShareholderList.tableManagerType))
            }
            
            it("should setup tableView") {
                // then
                let tableManager = view.tableManager
                expect(view.tableView.dataSource).to(beIdenticalTo(tableManager))
                expect(view.tableView.delegate).to(beIdenticalTo(tableManager))
                expect(view.tableView.backgroundColor)
                    .to(equal(TestData.PresentShareholderList.tableViewBackgroundColor))
            }
        }
        
        describe(".configure") {
            it("should ask table view to reload data") {
                // given
                view.tableManager = tableManagerMock
                view.tableView = tableViewMock
                // when
                view.configure(TestData.PresentShareholderList.viewModel)
                // then
                expect(tableManagerMock.setRowsWasCalled).to(beCalledOnce())
                expect(tableManagerMock.rows).to(equal(TestData.PresentShareholderList.rows))
                expect(tableViewMock.reloadDataWasCalled).to(beCalledOnce())
            }
        }
        
        describe(".didSelectShareholder") {
            it("should call delegate") {
                // when
                view.didSelectShareholder(TestData.PresentShareholderDetails.uid)
                // then
                expect(delegateMock.didSelectShareholderWasCalled).to(beCalledOnce())
                expect(delegateMock.didSelectShareholderReceivedUid)
                    .to(equal(TestData.PresentShareholderDetails.uid))
            }
        }
    }
}

// MARK: - TestData

private extension ShareholderListViewTests {
    enum TestData: Theme {
        static let cellViewModel = ShareholderListCellViewModel.Seeds.value
        static let unknownCompanyCellViewModel = ShareholderListCellViewModel.Seeds.valueCompanyUnknown
        
        enum PresentShareholderList {
            static let rows = [
                cellViewModel,
                unknownCompanyCellViewModel
            ]
            static let viewModel = ShareholderListDataFlow.PresentShareholderList.ViewModel(rows: rows)
            static let tableViewBackgroundColor = Palette.backgroundPrimary
            static let tableManagerType = ShareholderListTableManager.self
        }
        
        enum PresentShareholderDetails {
            static let uid = cellViewModel.uid
        }
    }
}
