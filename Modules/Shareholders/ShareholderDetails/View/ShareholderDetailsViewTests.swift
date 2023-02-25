// Created by Станислав on 16.02.2023.

import TestAdditions
import ABUIComponents
@testable import Shareholders

final class ShareholderDetailsViewTests: QuickSpec {
    override func spec() {
        var view: ShareholderDetailsView!
        
        beforeEach {
            view = .init()
        }
        
        describe(".init") {
            it("should setup view") {
                expect(view.backgroundColor).to(equal(TestData.backgroundColor))
            }
        }
    }
}

// MARK: - TestData

private extension ShareholderDetailsViewTests {
    enum TestData: Theme {
        static let backgroundColor = Palette.backgroundPrimary
    }
}
