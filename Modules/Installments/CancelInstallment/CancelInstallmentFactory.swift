//  Created by Рамазанов Виталий Глебович on 27/08/2021.

import SharedProtocolsAndModels
import SharedRouter

/**
 Полное название фичи: Отмена рассрочки кредитной карты
 Что делает: Позволяет отменять рассрочку
 Как попасть: Кредитный счёт -> Список рассрочек -> Экран детальной информации о рассрочке -> Отмена рассрочки
 Условия: Доступно в течение 24 часов после открытия рассрочки, без FT
 */
public struct CancelInstallmentContext: Equatable {
    let installment: Instalment
}

public struct CancelInstallmentFactory<Routes: CancelInstallmentRoutes>: Factory {
    // MARK: - Properties

    private let analyticsFacade: AnalyticsFacadeProtocol

    // MARK: - Lifecycle

    public init(analyticsFacade: AnalyticsFacadeProtocol) {
        self.analyticsFacade = analyticsFacade
    }

    // MARK: - Factory

    public func build(with context: CancelInstallmentContext) throws -> CancelInstallmentViewController<Routes> {
        let dataStore = CancelInstallmentDataStore(installment: context.installment)
        let presenter = CancelInstallmentPresenter()
        let service = CancellationDraftService()
        let provider = CancelInstallmentDocumentsProvider(
            cancellationDraftService: .init(service)
        )
        let viewController = CancelInstallmentViewController<Routes>(
            analytics: CancelInstallmentAnalytics(analyticsFacade: analyticsFacade),
            interactor: CancelInstallmentInteractor(
                presenter: presenter,
                documentsProvider: provider,
                confirmationProvider: .init(CancelInstallmentConfirmationProvider(
                    agreementNumber: context.installment.agreementNumber,
                    installmentNumber: context.installment.uid
                )
                ),
                dataStore: dataStore
            )
        )
        presenter.viewController = viewController
        return viewController
    }
}
