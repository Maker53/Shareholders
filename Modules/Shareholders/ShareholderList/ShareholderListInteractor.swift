// Created by Станислав on 07.02.2023.

import SharedPromiseKit
import SharedProtocolsAndModels

protocol ShareholderListBusinessLogic: AnyObject {
    func fetchShareholderList()
}

final class ShareholderListInteractor: ShareholderListBusinessLogic {
    // MARK: - Internal Properties
    
    let presenter: ShareholderListPresentationLogic
    let provider: ProvidesShareholderList
    
    // MARK: - Initializer
    
    init(presenter: ShareholderListPresentationLogic, provider: ProvidesShareholderList) {
        self.presenter = presenter
        self.provider = provider
    }
    
    // MARK: - ShareholderListBusinessLogic
    
    func fetchShareholderList() {
        let shareholderListPromise = provider.fetchShareholderList(usingCache: true)
        
        firstly {
            shareholderListPromise
        }.done { [weak self] in
            self?.presenter.presentShareholderList(.init(shareholders: $0))
        }.catch {
            ABLogError($0.localizedDescription)
        }
    }
}
