// Created by Станислав on 14.02.2023.

import AlfaFoundation
import TestAdditions
import ABUIComponents
@testable import Shareholders

final class ManagesShareholderListTableTests: QuickSpec {
    override func spec() {
        var tableManager: ShareholderListTableManager!
        var delegateMock: ShareholderListTableManagerDelegateMock!
        var tableViewMock: UITableViewMock!
        
        beforeEach {
            delegateMock = .init()
            tableViewMock = .init()
            tableManager = .init(delegate: delegateMock)
            tableViewMock.dataSource = tableManager
            tableViewMock.delegate = tableManager
        }
        
        describe(".init") {
            it("should init shareholders to empty") {
                // then
                expect(tableManager.rows).to(beEmpty())
            }
        }
        
        describe(".numberOfRowsInSection") {
            beforeEach {
                tableManager.rows = TestData.rows
            }
            
            it("should return correct number of rows") {
                // when
                let numberOfRows = tableManager.tableView(tableViewMock, numberOfRowsInSection: TestData.correctSection)
                // then
                expect(numberOfRows).to(equal(TestData.rows.count))
            }
            
            it("should return 0") {
                // when
                let numberOfRows = tableManager.tableView(tableViewMock, numberOfRowsInSection: TestData.incorrectSection)
                // then
                expect(numberOfRows).to(equal(0))
            }
        }
        
        describe(".cellForRowAt") {
            it("should get correct cell type ContactCell") {
                // given
                tableViewMock.dequeueReusableCellWithIdentifierStub = TestData.contactCell
                tableViewMock.dequeueReusableCellWithIdentifierForIndexPathStub = TestData.contactCell
                tableManager.rows = TestData.rows
                // when
                let cell = tableManager.tableView(tableViewMock, cellForRowAt: TestData.correctIndexPath)
                // then
                expect(cell).to(beAnInstanceOf(TestData.contactCellType))
            }
            
            it("should return UITableViewCell") {
                // when
                let cell = tableManager.tableView(tableViewMock, cellForRowAt: TestData.incorrectIndexPath)
                // then
                expect(cell).to(beAnInstanceOf(TestData.tableViewCellType))
            }
        }
        
        describe(".didSelectRowAt") {
            it("should call delegate") {
                // given
                tableManager.rows = TestData.rows
                // when
                tableManager.tableView(tableViewMock, didSelectRowAt: TestData.correctIndexPath)
                // then
                expect(tableViewMock.deselectRowWasCalled).to(beCalledOnce())
                expect(tableViewMock.deselectRowReceivedArguments?.indexPath).to(equal(TestData.correctIndexPath))
                expect(tableViewMock.deselectRowReceivedArguments?.animated).to(equal(true))
                expect(delegateMock.didSelectShareholderWasCalled).to(beCalledOnce())
                expect(delegateMock.didSelectShareholderReceivedUid).to(equal(TestData.uid))
            }
            
            it("shouldn't call delegate") {
                // when
                tableManager.tableView(tableViewMock, didSelectRowAt: TestData.incorrectIndexPath)
                // then
                expect(tableViewMock.deselectRowWasCalled).to(beCalledOnce())
                expect(tableViewMock.deselectRowReceivedArguments?.indexPath).to(equal(TestData.incorrectIndexPath))
                expect(tableViewMock.deselectRowReceivedArguments?.animated).to(equal(true))
                expect(delegateMock.didSelectShareholderWasCalled).toNot(beCalled())
            }
        }
    }
}

// MARK: - TestData

private extension ManagesShareholderListTableTests {
    enum TestData {
        static let correctSection = correctIndexPath.section
        static let incorrectSection = incorrectIndexPath.section
        static let correctIndexPath = IndexPath(row: 0, section: 0)
        static let incorrectIndexPath = IndexPath(row: 999, section: 999)
        static let uid: UniqueIdentifier = .init(row.uid)
        static let rows: [ShareholderCellViewModel] = [row]
        static let contactCell = ContactCell()
        static let contactCellType = ContactCell.self
        static let tableViewCellType = UITableViewCell.self
        
        // MARK: - Private
        
        static private let row = ShareholderCellViewModel.Seeds.value
    }
}
