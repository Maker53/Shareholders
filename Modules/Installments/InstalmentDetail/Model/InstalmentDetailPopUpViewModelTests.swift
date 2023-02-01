//  Created by Vitaliy Ramazanov on 17.02.2021.

import ABUIComponents
import TestAdditions

@testable import Installments

final class InstalmentDetailPopUpViewModelTests: QuickSpec {
    override func spec() {
        var model: InstalmentDetailPopUpViewModel!
        beforeEach {
            model = .init(
                title: TestData.title,
                rightIcon: TestData.icon
            )
        }
        describe(".init") {
            it("should init properly") {
                // given
                expect(model.title).to(equal(TestData.title))
                expect(model.rightIcon).to(equal(TestData.icon))
                expect(model.contentViewModel as? InstalmentDetailPopUpViewModel)
                    .to(equal(model))
                expect(model.dataContent).to(equal(TestData.dataContent))
                expect(model.icon).to(equal(TestData.icon))
                expect(model.useInWrapper).to(beTrue())
            }
        }
    }
}

private extension InstalmentDetailPopUpViewModelTests {
    enum TestData {
        static let title = "Title"
        static let icon = IconViewViewModel()
        static let dataContent = OldDataContentViewModel(title: title)
    }
}
