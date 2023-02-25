// Created by Станислав on 19.02.2023.

import TestAdditions
import ABUIComponents
@testable import Shareholders

final class ShareholderListViewSnapshots: QuickSpec {
    override func spec() {
        var view: ShareholderListView!
        var delegateMock: ShareholderListViewDelegateMock!
        
        beforeEach {
            delegateMock = .init()
            view = ShareholderListView(delegate: delegateMock)
        }

        describe(".configure") {
            context("when text fits into the label") {
                it("should have right representation") {
                    // when
                    view.configure(TestData.normalViewModel)
                    // then
                    expect(view).to(
                        beEqualSnapshot("ShareholderListViewSnapshot_normal"),
                        layout: .frameForFullScreen
                    )
                }
            }
            
            context("when text doesn't fits into the label") {
                it("should have right representation") {
                    // when
                    view.configure(TestData.longNameViewModel)
                    // then
                    expect(view).to(
                        beEqualSnapshot("ShareholderListViewSnapshot_longNames"),
                        layout: .frameForFullScreen
                    )
                }
            }
        }
    }
}

// MARK: - TestData

private extension ShareholderListViewSnapshots {
    enum TestData {
        static let normalRows = [
            ShareholderCellViewModel.Seeds.value,
            ShareholderCellViewModel.Seeds.valueCompanyUnknown,
            ShareholderCellViewModel.Seeds.value,
            ShareholderCellViewModel.Seeds.valueCompanyUnknown
        ]
        static let longNameRows = [
            ShareholderCellViewModel.Seeds.valueLongNames,
            ShareholderCellViewModel.Seeds.valueLongNames,
            ShareholderCellViewModel.Seeds.valueLongNames,
            ShareholderCellViewModel.Seeds.valueLongNames
        ]
        static let normalViewModel = ShareholderListDataFlow.PresentShareholderList.ViewModel(rows: normalRows)
        static let longNameViewModel = ShareholderListDataFlow.PresentShareholderList.ViewModel(rows: longNameRows)
    }
}
