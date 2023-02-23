// Created by Станислав on 07.02.2023.

import AlfaFoundation
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
    
    // MARK: - displayShareholderDetails
    
    private(set) var displayShareholderDetailsWasCalled = 0
    private(set) var displayShareholderDetailsViewModel: ShareholderListDataFlow.PresentShareholderDetails.ViewModel?
    
    func displayShareholderDetails(_ viewModel: ShareholderListDataFlow.PresentShareholderDetails.ViewModel) {
        displayShareholderDetailsWasCalled += 1
        displayShareholderDetailsViewModel = viewModel
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
    
    // MARK: - openShareholderDetails
    
    private(set) var openShareholderDetailsWasCalled = 0
    private(set) var openShareholderDetailsReceivedRequest: ShareholderListDataFlow.PresentShareholderDetails.Request?
    
    func openShareholderDetails(_ request: ShareholderListDataFlow.PresentShareholderDetails.Request) {
        openShareholderDetailsWasCalled += 1
        openShareholderDetailsReceivedRequest = request
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
    
    // MARK: - presentShareholderDetails
    
    private(set) var presentShareholderDetailsWasCalled = 0
    private(set) var presentShareholderDetailsReceivedResponse: ShareholderListDataFlow.PresentShareholderDetails.Response?
    
    func presentShareholderDetails(_ response: ShareholderListDataFlow.PresentShareholderDetails.Response) {
        presentShareholderDetailsWasCalled += 1
        presentShareholderDetailsReceivedResponse = response
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

public enum ShareholderListRoutesMock: ShareholderListRoutes {
    // MARK: - shareholderDetails
    
    static var shareholderDetailsStub = SharedRouter.Route { _ in }
    private(set) static var shareholderDetailsWasCalled = 0
    private(set) static var shareholderDetailsReceivedUid: UniqueIdentifier?
    
    public static func shareholderDetails(uid: UniqueIdentifier) -> Route {
        shareholderDetailsReceivedUid = uid
        defer { shareholderDetailsWasCalled += 1 }
        return shareholderDetailsStub
    }
}

final class ShareholderListTableManagerDelegateMock: ShareholderListTableManagerDelegate {
    // MARK: - didSelectShareholder
    
    private(set) var didSelectShareholderWasCalled = 0
    private(set) var didSelectShareholderReceivedUid: UniqueIdentifier?
    
    func didSelectShareholder(_ uid: UniqueIdentifier) {
        didSelectShareholderWasCalled += 1
        didSelectShareholderReceivedUid = uid
    }
}

final class ShareholderListTableManagerProtocolMock: UITableViewDataSourceMock, ShareholderListTableManagerProtocol {
    // MARK: - Shareholders
    
    private(set) var getRowsWasCalled = 0
    private(set) var setRowsWasCalled = 0
    var rowsStub: [ShareholderCellViewModel] = []
    var rows: [ShareholderCellViewModel] {
        get {
            getRowsWasCalled += 1
            return rowsStub
        }
        set {
            setRowsWasCalled += 1
            rowsStub = newValue
        }
    }
}

final class ShareholderListViewDelegateMock: ShareholderListViewDelegate {
    // MARK: - didSelectShareholder
    
    private(set) var didSelectShareholderWasCalled = 0
    private(set) var didSelectShareholderReceivedUid: UniqueIdentifier?
    
    func didSelectShareholder(_ uid: UniqueIdentifier) {
        didSelectShareholderWasCalled += 1
        didSelectShareholderReceivedUid = uid
    }
}
