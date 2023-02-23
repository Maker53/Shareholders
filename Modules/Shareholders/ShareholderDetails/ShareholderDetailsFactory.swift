// Created by Станислав on 16.02.2023.

import AlfaFoundation
import SharedRouter

public struct ShareholderDetailsFactory<Routes: ShareholderDetailsRoutes>: Factory {
    public typealias ViewController = ShareholderDetailsViewController
    public typealias Context = UniqueIdentifier
    
    public init() { }
    
    public func build(with context: Context) throws -> ViewController<Routes> {
        // TODO Датастор будет синглтоном, поправить после rebase
        let provider = ShareholderDetailsProvider(dataStore: ShareholderListDataStore())
        
        let presenter = ShareholderDetailsPresenter()
        let interactor = ShareholderDetailsInteractor(presenter: presenter, provider: provider)
        let viewController = ShareholderDetailsViewController<Routes>(interactor: interactor, uid: context)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
