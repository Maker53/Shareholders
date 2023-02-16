// Created by Станислав on 14.02.2023.

import TestAdditions
import ABUIComponents
@testable import Shareholders

final class ManagesShareholderListTableTests: QuickSpec {
    override func spec() {
        var tableManager: ShareholderListTableManager!
        var tableViewMock: UITableViewMock!
        
        beforeEach {
            tableViewMock = .init()
            tableManager = .init()
            tableViewMock.dataSource = tableManager
        }
        
        describe(".init") {
            it("should init shareholders to empty") {
                // then
                expect(tableManager.shareholders).to(beEmpty())
            }
        }
        
        describe(".numberOfRowsInSection") {
            beforeEach {
                tableManager.shareholders = TestData.shareholders
            }
            
            it("should return correct number of rows") {
                // when
                let numberOfRows = tableManager.tableView(tableViewMock, numberOfRowsInSection: TestData.correctSection)
                // then
                expect(numberOfRows).to(equal(TestData.shareholders.count))
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
                tableManager.shareholders = TestData.shareholders
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
    }
}

// MARK: - TestData

private extension ManagesShareholderListTableTests {
    enum TestData {
        static let correctSection = correctIndexPath.section
        static let incorrectSection = incorrectIndexPath.section
        static let correctIndexPath = IndexPath(row: 0, section: 0)
        static let incorrectIndexPath = IndexPath(row: 999, section: 999)
        static let shareholders: [Shareholder] = [.Seeds.value]
        static let contactCell = ContactCell()
        static let contactCellType = ContactCell.self
        static let tableViewCellType = UITableViewCell.self
    }
}
