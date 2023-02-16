// Created by Станислав on 16.02.2023.

import TestAdditions
@testable import Shareholders

final class ShareholderDetailsInteractorTests: QuickSpec {
    override func spec() {
        var presenterMock: ShareholderDetailsPresentationLogicMock!
        var intractor: ShareholderDetailsInteractor!
        
        beforeEach {
            presenterMock = .init()
            intractor = .init(presenter: presenterMock)
        }
    }
}
