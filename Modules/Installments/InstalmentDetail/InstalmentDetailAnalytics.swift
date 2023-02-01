//  Created by Lyudmila Danilchenko on 25/10/2020.

import SharedProtocolsAndModels

protocol InstalmentDetailEvents: AnyObject {
    func trackScreen()
    func trackButtonTap()
}

final class InstalmentDetailAnalytics: InstalmentDetailEvents {
    // MARK: - Properties

    let analyticsFacade: AnalyticsFacadeProtocol
    let installmentType: InstallmentType

    private var screenName: String {
        switch installmentType {
        case .credit:
            return Configuration.creditScreenName
        case .debit, .promotional:
            return Configuration.debitScreenName
        }
    }

    private var screenLabel: String {
        switch installmentType {
        case .credit:
            return Configuration.Labels.creditScreenOpened
        case .debit, .promotional:
            return Configuration.Labels.debitScreenOpened
        }
    }

    private var buttonLabel: String {
        switch installmentType {
        case .credit:
            return Configuration.Labels.creditButtonClick
        case .debit, .promotional:
            return Configuration.Labels.debitButtonClick
        }
    }

    // MARK: - Lifecycle

    init(
        analyticsFacade: AnalyticsFacadeProtocol,
        installmentType: InstallmentType
    ) {
        self.analyticsFacade = analyticsFacade
        self.installmentType = installmentType
    }

    // MARK: - InstalmentDetailEvents

    func trackScreen() {
        analyticsFacade.track(
            event: AnalyticsEvent(
                category: Configuration.category,
                action: .impression,
                label: screenLabel,
                screenName: screenName
            )
        )
    }

    func trackButtonTap() {
        analyticsFacade.track(
            event: AnalyticsEvent(
                category: Configuration.category,
                action: .click,
                label: buttonLabel,
                screenName: screenName
            )
        )
    }
}

// MARK: - Private

private extension InstalmentDetailAnalytics {
    enum Configuration {
        enum Labels {
            static let creditScreenOpened = "Credit Installment Details Screen Opened"
            static let debitScreenOpened = "Debit Installment Details Screen Opened"
            static let creditButtonClick = "Credit Installment Early Repayment Button Click"
            static let debitButtonClick = "Debit Installment Early Repayment Button Click"
        }

        static let creditScreenName = "Credit Installment Details Screen"
        static let debitScreenName = "Debit Installment Details Screen"

        static let category = "Installment"
    }
}
