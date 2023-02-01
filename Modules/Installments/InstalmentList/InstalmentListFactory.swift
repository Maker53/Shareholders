//  Created by Lyudmila Danilchenko on 17/08/2020.

import AlfaNetworking
import SharedProtocolsAndModels
import SharedRouter

public struct InstalmentListFactory<Routes: InstalmentListRoutes>: Factory {
    // MARK: - Properties

    private let analyticsFacade: AnalyticsFacadeProtocol
    private let featuresService: FeaturesServiceProtocol

    // MARK: - Lifecycle

    public init(
        analyticsFacade: AnalyticsFacadeProtocol,
        featuresService: FeaturesServiceProtocol
    ) {
        self.analyticsFacade = analyticsFacade
        self.featuresService = featuresService
    }

    // MARK: - Factory

    public func build(with _: Any?) throws -> InstalmentListViewController<Routes> {
        let presenter = InstalmentListPresenter()

        let installmentListService = AnyNetworkService(InstalmentListService())
        let offerService = AnyNetworkService(InstalmentOfferService())

        let provider = InstalmentListProvider(service: installmentListService, serviceOffer: offerService)

        let viewController = InstalmentListViewController<Routes>(
            analytics: InstalmentListAnalytics(analyticsFacade: analyticsFacade),
            interactor: InstalmentListInteractor(
                presenter: presenter,
                provider: provider,
                featuresService: featuresService
            )
        )
        presenter.viewController = viewController

        return viewController
    }
}
