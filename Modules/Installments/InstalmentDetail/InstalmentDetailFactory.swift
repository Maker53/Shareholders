//  Created by Lyudmila Danilchenko on 25/10/2020.

import AlfaNetworking
import SharedProtocolsAndModels
import SharedRouter

/**
 Полное название фичи: Детальная страница рассрочки
 Что делает: Показывает информацию о рассрочке
 Как попасть:
 1. Дашборд -> Экран счета -> Рассрочки -> Деталка
 2. Диплинк /instalments/loan_detail
 */
public struct InstalmentDetailFactory<Routes: InstalmentDetailRoutes>: Factory {
    // MARK: - Properties

    private let analyticsFacade: AnalyticsFacadeProtocol
    private let featureService: FeaturesServiceProtocol

    // MARK: - Lifecycle

    public init(
        analyticsFacade: AnalyticsFacadeProtocol,
        featureService: FeaturesServiceProtocol
    ) {
        self.analyticsFacade = analyticsFacade
        self.featureService = featureService
    }

    // MARK: - Factory

    public func build(with context: InstallmentDetailsContext) throws -> InstalmentDetailViewController<Routes> {
        let presenter = InstalmentDetailPresenter(featureService: featureService)

        let dataStore = InstallmentDetailDataStore(context: context)
        let installmentListService = AnyNetworkService(InstalmentListService())

        let provider = InstallmentDetailProvider(dataStore: dataStore, service: installmentListService)

        let installmentType: InstallmentType
        switch context {
        case let .full(fullModel):
            installmentType = fullModel.installmentType
        case let .plain(plainModel):
            installmentType = plainModel.installmentType
        }
        let viewController = InstalmentDetailViewController<Routes>(
            analytics: InstalmentDetailAnalytics(analyticsFacade: analyticsFacade, installmentType: installmentType),
            interactor: InstalmentDetailInteractor(
                presenter: presenter,
                provider: provider
            )
        )
        presenter.viewController = viewController
        return viewController
    }
}
