//  Created by Рамазанов Виталий Глебович on 27/08/2021.

import OperationConfirmation
import SharedProtocolsAndModels

protocol CancelInstallmentEvents: AnyObject {
    func trackScreen()
    func getConfirmationScreenName() -> String
}

final class CancelInstallmentAnalytics: CancelInstallmentEvents {
    // MARK: - Properties

    private let analyticsFacade: AnalyticsFacadeProtocol

    // MARK: - Lifecycle

    init(analyticsFacade: AnalyticsFacadeProtocol) {
        self.analyticsFacade = analyticsFacade
    }

    // MARK: - CancelInstallmentEvents

    func trackScreen() {
        analyticsFacade.track(
            event: AnalyticsEvent(
                category: Configuration.category,
                action: .impression,
                label: Configuration.Labels.screenOpened,
                screenName: Configuration.screenName
            )
        )
    }

    func getConfirmationScreenName() -> String {
        Configuration.confirmationScreenName
    }
}

// MARK: - ConfirmationAnalytics

extension CancelInstallmentAnalytics: ConfirmationAnalytics {
    func trackConfirmationReferenceSuccess() {
        analyticsFacade.track(event: AnalyticsEvent(
            category: Configuration.category,
            action: .submit,
            label: Configuration.Labels.smsSuccess,
            screenName: Configuration.confirmationScreenName
        ))
    }
}

// MARK: - Private

private extension CancelInstallmentAnalytics {
    enum Configuration {
        enum Labels {
            static let smsSuccess = "Credit Cancellanion SMS Success"
            static let screenOpened = "Credit Installment Cancellation Screen Opened"
        }

        static let screenName = "Credit Installment Cancellation Screen"
        static let confirmationScreenName = "Credit Installment Cancellation Confirmation Screen"
        static let category = "Installment"
    }
}
