//  Created by Lyudmila Danilchenko on 17/08/2020.

import SharedProtocolsAndModels

protocol InstalmentListEvents: AnyObject {
    func trackScreen()
    func trackError(_ text: String)
}

final class InstalmentListAnalytics: InstalmentListEvents {
    // MARK: - Properties

    private let analyticsFacade: AnalyticsFacadeProtocol

    // MARK: - Lifecycle

    init(analyticsFacade: AnalyticsFacadeProtocol) {
        self.analyticsFacade = analyticsFacade
    }

    // MARK: - InstalmentListEvents

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

    func trackError(_ text: String) {
        analyticsFacade.track(
            event: AnalyticsEvent(
                category: Configuration.category,
                action: .impression,
                dimensions: [.eventState(.error(text))],
                label: Configuration.Labels.screenError,
                screenName: Configuration.screenName
            )
        )
    }
}

// MARK: - Private

private extension InstalmentListAnalytics {
    enum Configuration {
        enum Labels {
            static let screenError = "Installment List Screen Error"
            static let screenOpened = "Installment List Screen Opened"
        }

        static let screenName = "Installment List Screen"
        static let category = "Installment"
    }
}
