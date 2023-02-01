//  Created by Lyudmila Danilchenko on 01.09.2021.

import ABUIComponents
import TestAdditions

@testable import Installments

final class CancelViewSnapshots: QuickSpec {
    override func spec() {
        var view: CancelView!

        beforeEach {
            view = .init()
        }

        describe(".init") {
            it("should look good") {
                // when
                view.backgroundColor = TestData.Palette.backgroundPrimary
                // then
                expect(view).to(beEqualSnapshot("CancelView_init"), layout: .frameForFullWidthScreen(height: 128))
            }
        }
    }
}

private extension CancelViewSnapshots {
    enum TestData: Theme { }
}
