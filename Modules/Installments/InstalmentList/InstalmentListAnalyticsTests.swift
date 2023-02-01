//  Created by Lyudmila Danilchenko on 17/08/2020.

import SharedProtocolsAndModels
import TestAdditions

@testable import Installments

final class InstalmentListAnalyticsTests: QuickSpec {
    override func spec() {
        var analytics: InstalmentListAnalytics!
        var analyticsFacadeMock: AnalyticsFacadeMock!

        beforeEach {
            analyticsFacadeMock = AnalyticsFacadeMock()
            analytics = InstalmentListAnalytics(analyticsFacade: analyticsFacadeMock)
        }

        describe(".trackScreen") {
            it("should track screen") {
                // when
                analytics.trackScreen()
                // then
                expect(analyticsFacadeMock.trackEventWasCalled).to(beCalledOnce())
                expect(analyticsFacadeMock.trackEventReceivedEvent).to(equal(TestData.screenEvent))
            }
        }

        describe(".trackError") {
            it("should track error") {
                // when
                analytics.trackError(TestData.errorMessage)
                // then
                expect(analyticsFacadeMock.trackEventWasCalled).to(beCalledOnce())
                expect(analyticsFacadeMock.trackEventReceivedEvent).to(equal(TestData.errorEvent))
            }
        }
    }
}

private extension InstalmentListAnalyticsTests {
    enum TestData {
        static let screenEvent = AnalyticsEvent(
            category: category,
            action: .impression,
            label: screenOpened,
            screenName: screenName
        )

        static let errorEvent = AnalyticsEvent(
            category: category,
            action: .impression,
            dimensions: [.eventState(.error(errorMessage))],
            label: screenError,
            screenName: screenName
        )

        static let errorMessage = "errorMessage"
        static let screenError = "Installment List Screen Error"
        static let screenOpened = "Installment List Screen Opened"
        static let screenName = "Installment List Screen"
        static let category = "Installment"
    }
}
