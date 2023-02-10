// Created by Станислав on 07.02.2023.

import ABUIComponents

final class StoresShareholderListMock: StoresShareholderList {
    private(set) var getShareholderListModelWasCalled = 0
    private(set) var setShareholderListModelWasCalled = 0
    var shareholderListModelStub: ShareholderList?
    var shareholderListModel: ShareholderList? {
        get {
            getShareholderListModelWasCalled += 1
            return shareholderListModelStub
        }
        set {
            setShareholderListModelWasCalled += 1
            shareholderListModelStub = newValue
        }
    }
}

final class ShareholderListTableManagerProtocolMock: UITableViewDataSourceMock, ShareholderListTableManagerProtocol {
    // MARK: - Shareholders
    
    var shareholders: [Shareholder] = []
}

final class ShareholderListViewDelegateMock: ShareholderListViewDelegate { }
