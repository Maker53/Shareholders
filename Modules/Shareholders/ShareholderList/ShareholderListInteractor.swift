// Created by Станислав on 07.02.2023.

protocol ShareholderListBusinessLogic: AnyObject {
    func fetchShareholderList(_ request: ShareholderListDataFlow.PresentShareholderList.Request)
}

final class ShareholderListInteractor: ShareholderListBusinessLogic {
    // MARK: - Internal Properties
    
    let presenter: ShareholderListPresentationLogic
    
    // MARK: - Initializer
    
    init(presenter: ShareholderListPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - ShareholderListBusinessLogic
    
    func fetchShareholderList(_ request: ShareholderListDataFlow.PresentShareholderList.Request) {
        presenter.presentShareholderList(.init())
    }
}
