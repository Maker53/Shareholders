// Created by Станислав on 16.02.2023.

import AlfaFoundation
import SharedProtocolsAndModels
import SharedRouter

public struct ShareholderDetailsFactory<Routes: ShareholderDetailsRoutes>: Factory {
    public typealias ViewController = ShareholderDetailsViewController
    public typealias Context = UniqueIdentifier
    
    // MARK: - Private Properties
    
    private let featureService: FeaturesServiceProtocol
    
    public init(featureService: FeaturesServiceProtocol) {
        self.featureService = featureService
    }
    
    public func build(with context: Context) throws -> ViewController<Routes> {
        let provider = ShareholderDetailsProvider(dataStore: ShareholderListDataStore.sharedInstance)
        
        let presenter = ShareholderDetailsPresenter(featureService: featureService)
        let interactor = ShareholderDetailsInteractor(presenter: presenter, provider: provider)
        let viewController = ShareholderDetailsViewController<Routes>(interactor: interactor, uid: context)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
