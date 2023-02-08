// Created by Станислав on 07.02.2023.

import SharedRouter

public struct ShareholderListFactory<Routes: ShareholderListRoutes>: Factory {
    public typealias ViewController = ShareholderListViewController
    public typealias Context = Any?
    
    public init() { }
    
    public func build(with context: Context) throws -> ViewController<Routes> {
        let presenter = ShareholderListPresenter()
        let interactor = ShareholderListInteractor(presenter: presenter)
        let viewController = ShareholderListViewController<Routes>(interactor: interactor)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
