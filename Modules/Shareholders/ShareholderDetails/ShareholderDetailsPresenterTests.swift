// Created by Станислав on 16.02.2023.

import TestAdditions
@testable import Shareholders

final class ShareholderDetailsPresenterTests: QuickSpec {
    override func spec() {
        var viewControllerMock: ShareholderDetailsDisplayLogicMock!
        var presenter: ShareholderDetailsPresenter!
        
        beforeEach {
            viewControllerMock = .init()
            presenter = .init()
            presenter.viewController = viewControllerMock
        }
    }
}
