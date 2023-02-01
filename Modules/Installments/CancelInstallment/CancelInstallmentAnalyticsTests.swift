//  Created by Рамазанов Виталий Глебович on 27/08/2021.

import SharedProtocolsAndModels
import TestAdditions

@testable import Installments

final class CancelInstallmentAnalyticsTests: QuickSpec {
    override func spec() {
        var analytics: CancelInstallmentAnalytics!
        var analyticsFacadeMock: AnalyticsFacadeMock!

        beforeEach {
            analyticsFacadeMock = AnalyticsFacadeMock()
            analytics = CancelInstallmentAnalytics(analyticsFacade: analyticsFacadeMock)
        }

        describe(".trackScreen") {
            it("should track screen") {
                // when
                analytics.trackScreen()
                // then
                expect(analyticsFacadeMock.trackEventWasCalled).to(beCalledOnce())
                expect(analyticsFacadeMock.trackEventReceivedEvent).to(equal(TestData.Screen.event))
            }
        }

        describe(".getConfirmationScreenName") {
            it("should provide correct value") {
                // then
                expect(analytics.getConfirmationScreenName()).to(equal(TestData.Confirmation.screenName))
            }
        }

        describe(".trackConfirmationReferenceSuccess") {
            it("should track event") {
                // when
                analytics.trackConfirmationReferenceSuccess()
                // then
                expect(analyticsFacadeMock.trackEventWasCalled).to(beCalledOnce())
                expect(analyticsFacadeMock.trackEventReceivedEvent).to(equal(TestData.Confirmation.event))
            }
        }
    }
}

private extension CancelInstallmentAnalyticsTests {
    enum TestData {
        enum Confirmation {
            static let screenName = "Credit Installment Cancellation Confirmation Screen"
            static let smsSuccess = "Credit Cancellanion SMS Success"

            static let event = AnalyticsEvent(
                category: category,
                action: .submit,
                label: smsSuccess,
                screenName: screenName
            )
        }

        enum Screen {
            static let screenName = "Credit Installment Cancellation Screen"
            static let screenOpened = "Credit Installment Cancellation Screen Opened"

            static let event = AnalyticsEvent(
                category: category,
                action: .impression,
                label: screenOpened,
                screenName: screenName
            )
        }

        static let category = "Installment"
    }
}
