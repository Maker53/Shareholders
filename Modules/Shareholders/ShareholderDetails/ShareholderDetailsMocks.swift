// Created by Станислав on 16.02.2023.

import AlfaFoundation
import SharedPromiseKit

final class ShareholderDetailsDisplayLogicMock: ShareholderDetailsDisplayLogic {
    // MARK: - displayShareholderDetails
    
    private(set) var displayShareholderDetailsWasCalled = 0
    private(set) var displayShareholderDetailsReceivedViewModel: ShareholderDetailsDataFlow.PresentShareholderDetails.ViewModel?
    
    func displayShareholderDetails(_ viewModel: ShareholderDetailsDataFlow.PresentShareholderDetails.ViewModel) {
        displayShareholderDetailsWasCalled += 1
        displayShareholderDetailsReceivedViewModel = viewModel
    }
}

final class DisplaysShareholderDetailsViewMock: UIView, DisplaysShareholderDetailsView {
    // MARK: - configure
    
    private(set) var configureWasCalled = 0
    private(set) var configureReceivedRequest: ShareholderDetailsDataFlow.PresentShareholderDetails.ViewModel?
    
    func configure(_ viewModel: ShareholderDetailsDataFlow.PresentShareholderDetails.ViewModel) {
        configureWasCalled += 1
        configureReceivedRequest = viewModel
    }
}

final class ShareholderDetailsBusinessLogicMock: ShareholderDetailsBusinessLogic {
    // MARK: - fetchShareholderDetails
    
    private(set) var fetchShareholderDetailsWasCalled = 0
    private(set) var fetchShareholderDetailsReceivedRequest: ShareholderDetailsDataFlow.PresentShareholderDetails.Request?
    
    func fetchShareholderDetails(_ request: ShareholderDetailsDataFlow.PresentShareholderDetails.Request) {
        fetchShareholderDetailsWasCalled += 1
        fetchShareholderDetailsReceivedRequest = request
    }
}

final class ShareholderDetailsPresentationLogicMock: ShareholderDetailsPresentationLogic {
    // MARK: - presentShareholderDetails
    
    private(set) var presentShareholderDetailsWasCalled = 0
    private(set) var presentShareholderDetailsReceivedResponse: ShareholderDetailsDataFlow.PresentShareholderDetails.Response?
    
    func presentShareholderDetails(_ response: ShareholderDetailsDataFlow.PresentShareholderDetails.Response) {
        presentShareholderDetailsWasCalled += 1
        presentShareholderDetailsReceivedResponse = response
    }
}

final class ProvidesShareholderDetailsMock: ProvidesShareholderDetails {
    // MARK: - fetchShareholderDetails
    
    private(set) var fetchShareholderDetailsWasCalled = 0
    private(set) var fetchShareholderDetailsReceivedId: UniqueIdentifier?
    var fetchShareholderDetailsStub: Promise<Shareholder>!
    
    func fetchShareholderDetails(id: UniqueIdentifier) -> Promise<Shareholder> {
        fetchShareholderDetailsWasCalled += 1
        fetchShareholderDetailsReceivedId = id
        
        return fetchShareholderDetailsStub
    }
}

public final class ShareholderDetailsRoutesMock: ShareholderDetailsRoutes {
    // MARK: - Initializer
    
    public init() { }
}
