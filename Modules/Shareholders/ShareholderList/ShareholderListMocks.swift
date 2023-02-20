// Created by Станислав on 07.02.2023.

import SharedRouter
import SharedPromiseKit
import ABUIComponents

final class ShareholderListDisplayLogicMock: ShareholderListDisplayLogic {
    // MARK: - displayShareholedList
    
    private(set) var displayShareholedListWasCalled = 0
    private(set) var displayShareholedListReceivedViewModel: ShareholderListDataFlow.PresentShareholderList.ViewModel?
    
    func displayShareholedList(_ viewModel: ShareholderListDataFlow.PresentShareholderList.ViewModel) {
        displayShareholedListWasCalled += 1
        displayShareholedListReceivedViewModel = viewModel
    }
}

final class DisplayShareholderListViewMock: UIView, DisplayShareholderListView {
    // MARK: - configure
    
    private(set) var configureWasCalled = 0
    private(set) var configureReceivedViewModel: ShareholderListDataFlow.PresentShareholderList.ViewModel?
    
    func configure(_ viewModel: ShareholderListDataFlow.PresentShareholderList.ViewModel) {
        configureWasCalled += 1
        configureReceivedViewModel = viewModel
    }
}

final class ShareholderListBusinessLogicMock: ShareholderListBusinessLogic {
    // MARK: - fetchShareholderList
    
    var fetchShareholderListWasCalled = 0
    
    func fetchShareholderList() {
        fetchShareholderListWasCalled += 1
    }
}

final class ShareholderListPresentationLogicMock: ShareholderListPresentationLogic {
    // MARK: - presentShareholderList
    
    private(set) var presentShareholderListWasCalled = 0
    private(set) var presentShareholderListReceivedResponse: ShareholderListDataFlow.PresentShareholderList.Response?
    
    func presentShareholderList(_ response: ShareholderListDataFlow.PresentShareholderList.Response) {
        presentShareholderListWasCalled += 1
        presentShareholderListReceivedResponse = response
    }
}

final class ProvidesShareholderListMock: ProvidesShareholderList {
    // MARK: - fetchShareholderList
    
    private(set) var fetchShareholderListWasCalled = 0
    private(set) var fetchShareholderListWasCalledReceivedUsingCache: Bool?
    var fetchShareholderListStub: Promise<ShareholderList>!
    
    func fetchShareholderList(usingCache: Bool) -> Promise<ShareholderList> {
        fetchShareholderListWasCalled += 1
        fetchShareholderListWasCalledReceivedUsingCache = usingCache
        
        return fetchShareholderListStub
    }
}

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

public final class ShareholderListRoutesMock: ShareholderListRoutes {
    // MARK: - Initializer
    
    public init() { }
}

final class ShareholderListTableManagerProtocolMock: UITableViewDataSourceMock, ShareholderListTableManagerProtocol {
    // MARK: - Shareholders
    
    var rows: [ShareholderListCellViewModel] = []
}

final class ShareholderListViewDelegateMock: ShareholderListViewDelegate { }
