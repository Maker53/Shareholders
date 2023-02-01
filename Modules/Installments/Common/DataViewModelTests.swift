//  Created by Виталий Рамазанов on 01.03.2021.

import ABUIComponents
import TestAdditions

@testable import Installments

final class DataViewModelTests: QuickSpec {
    override func spec() {
        var model: DataViewModel!

        beforeEach {
            model = .init(
                dataContent: OldDataContentViewModel(title: "1234"),
                icon: IconViewViewModel()
            )
        }

        describe(".init") {
            context("with default param") {
                it("should have useInWrapper = false") {
                    // then
                    expect(model.dataContent).to(equal(OldDataContentViewModel(title: "1234")))
                    expect(model.icon).to(equal(IconViewViewModel()))
                    expect(model.useInWrapper).to(beFalse())
                }
            }
        }
    }
}
