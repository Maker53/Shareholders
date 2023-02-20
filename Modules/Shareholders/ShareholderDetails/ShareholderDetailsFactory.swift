// Created by Станислав on 16.02.2023.

import AlfaFoundation
import SharedRouter

public struct ShareholderDetailsFactory<Routes: ShareholderDetailsRoutes>: Factory {
    public typealias ViewController = ShareholderDetailsViewController
    public typealias Context = UniqueIdentifier
    
    public init() { }
    
    public func build(with context: Context) throws -> ViewController<Routes> {
        let presenter = ShareholderDetailsPresenter()
        let interactor = ShareholderDetailsInteractor(presenter: presenter)
        let viewController = ShareholderDetailsViewController<Routes>(interactor: interactor)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
