// Created by Станислав on 16.02.2023.

import TestAdditions
import ABUIComponents
@testable import Shareholders

final class ShareholderDetailsViewSnapshots: QuickSpec {
    override func spec() {
        var view: ShareholderDetailsView!
        
        beforeEach {
            view = .init()
        }
        
        describe(".configure") {
            context("when text fits into the label") {
                it("should have right representation") {
                    // when
                    view.configure(TestData.normalViewModel)
                    // then
                    expect(view).to(
                        beEqualSnapshot("ShareholderDetailsViewSnapshot_normal"),
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
                        beEqualSnapshot("ShareholderDetailsViewSnapshot_longNames"),
                        layout: .frameForFullScreen
                    )
                }
            }
        }
    }
}

// MARK: - TestData

private extension ShareholderDetailsViewSnapshots {
    enum TestData {
        static let normalViewModel = ShareholderDetailsDataFlow.PresentShareholderDetails.ViewModel(
            shareholderDetails: normalCellViewModel
        )
        static let longNameViewModel = ShareholderDetailsDataFlow.PresentShareholderDetails.ViewModel(
            shareholderDetails: longNameCellViewModel
        )
        
        // MARK: - Private
        
        private static let normalCellViewModel = ShareholderCellViewModel.Seeds.value
        private static let longNameCellViewModel = ShareholderCellViewModel.Seeds.valueLongNames
    }
}
