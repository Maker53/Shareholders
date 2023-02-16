// Created by Станислав on 16.02.2023.

protocol ShareholderDetailsBusinessLogic: AnyObject { }

final class ShareholderDetailsInteractor: ShareholderDetailsBusinessLogic {
    // MARK: - Internal Properties
    
    let presenter: ShareholderDetailsPresentationLogic
    
    // MARK: - Initializer
    
    init(presenter: ShareholderDetailsPresentationLogic) {
        self.presenter = presenter
    }
}
