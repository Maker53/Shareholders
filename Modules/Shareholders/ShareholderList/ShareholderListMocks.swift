// Created by Станислав on 07.02.2023.

import SharedRouter

final class ShareholderListDisplayLogicMock: ShareholderListDisplayLogic {
    // MARK: - displayShareholedList
    
    private(set) var displayShareholedListWasCalled = 0
    private(set) var displayShareholedListReceivedViewModel: ShareholderListDataFlow.PresentShareholderList.ViewModel?
    
    func displayShareholedList(_ viewModel: ShareholderListDataFlow.PresentShareholderList.ViewModel) {
        displayShareholedListWasCalled += 1
        displayShareholedListReceivedViewModel = viewModel
    }
}

final class DisplayShareholderListViewMock: UIView, DisplayShareholderListView { }

final class ShareholderListBusinessLogicMock: ShareholderListBusinessLogic {
    // MARK: - fetchShareholderList
    
    var fetchShareholderListWasCalled = 0
    var fetchShareholderListReceivedRequest: ShareholderListDataFlow.PresentShareholderList.Request?
    
    func fetchShareholderList(_ request: ShareholderListDataFlow.PresentShareholderList.Request) {
        fetchShareholderListWasCalled += 1
        fetchShareholderListReceivedRequest = request
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

public final class ShareholderListRoutesMock: ShareholderListRoutes {
    // MARK: - Initializer
    
    public init() { }
}
