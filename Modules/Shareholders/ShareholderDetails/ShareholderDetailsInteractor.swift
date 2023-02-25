// Created by Станислав on 16.02.2023.

import SharedPromiseKit
import SharedProtocolsAndModels

protocol ShareholderDetailsBusinessLogic: AnyObject {
    func fetchShareholderDetails(_ request: ShareholderDetailsDataFlow.PresentShareholderDetails.Request)
}

final class ShareholderDetailsInteractor: ShareholderDetailsBusinessLogic {
    // MARK: - Internal Properties
    
    let presenter: ShareholderDetailsPresentationLogic
    let provider: ProvidesShareholderDetails
    
    // MARK: - Initializer
    
    init(presenter: ShareholderDetailsPresentationLogic, provider: ProvidesShareholderDetails) {
        self.presenter = presenter
        self.provider = provider
    }
    
    // MARK: - ShareholderDetailsBusinessLogic
    
    func fetchShareholderDetails(_ request: ShareholderDetailsDataFlow.PresentShareholderDetails.Request) {
        firstly {
            provider.fetchShareholderDetails(id: request.uid)
        }.done { [weak self] in
            self?.presenter.presentShareholderDetails(.init(shareholderDetails: $0))
        }.catch {
            ABLogError($0.localizedDescription)
        }
    }
}
