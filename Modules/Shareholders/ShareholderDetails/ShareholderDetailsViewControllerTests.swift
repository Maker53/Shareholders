// Created by Станислав on 16.02.2023.

import TestAdditions
import ABUIComponents
@testable import Shareholders

final class ShareholderDetailsViewControllerTests: QuickSpec {
    override func spec() {
        var interactorMock: ShareholderDetailsBusinessLogicMock!
        var contentViewMock: DisplaysShareholderDetailsViewMock!
        var viewController: ShareholderDetailsViewController<ShareholderDetailsRoutesMock>!
        
        beforeEach {
            interactorMock = .init()
            contentViewMock = .init()
            viewController = .init(interactor: interactorMock)
        }
        
        describe(".loadView") {
            it("should setup view") {
                // when
                viewController.contentView = contentViewMock
                // then
                expect(viewController.view).to(beIdenticalTo(contentViewMock))
                expect(viewController.view.backgroundColor).to(equal(TestData.contentViewBackgroundColor))
            }
        }
    }
}

// MARK: - TestData

private extension ShareholderDetailsViewControllerTests {
    enum TestData {
        static let contentViewBackgroundColor = appearance.palette.backgroundPrimary
        static let appearance = Appearance(); struct Appearance: Theme { }
    }
}
