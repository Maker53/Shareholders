//  Created by Lyudmila Danilchenko on 25/10/2020.

import SharedProtocolsAndModels
import TestAdditions

@testable import Installments

final class InstalmentDetailAnalyticsTests: QuickSpec {
    override func spec() {
        var analytics: InstalmentDetailAnalytics!
        var analyticsFacadeMock: AnalyticsFacadeMock!

        beforeEach {
            analyticsFacadeMock = AnalyticsFacadeMock()
        }

        describe(".trackScreen") {
            context("when debit installment") {
                it("should track screen") {
                    // given
                    analytics = InstalmentDetailAnalytics(analyticsFacade: analyticsFacadeMock, installmentType: .debit)
                    // when
                    analytics.trackScreen()
                    // then
                    expect(analyticsFacadeMock.trackEventWasCalled).to(beCalledOnce())
                    expect(analyticsFacadeMock.trackEventReceivedEvent).to(equal(TestData.Debit.event))
                }
            }
            context("when credit installment") {
                it("should track screen") {
                    // given
                    analytics = InstalmentDetailAnalytics(analyticsFacade: analyticsFacadeMock, installmentType: .credit)
                    // when
                    analytics.trackScreen()
                    // then
                    expect(analyticsFacadeMock.trackEventWasCalled).to(beCalledOnce())
                    expect(analyticsFacadeMock.trackEventReceivedEvent).to(equal(TestData.Credit.event))
                }
            }
            context("when promotion installment") {
                it("should track screen") {
                    // given
                    analytics = InstalmentDetailAnalytics(analyticsFacade: analyticsFacadeMock, installmentType: .promotional)
                    // when
                    analytics.trackScreen()
                    // then
                    expect(analyticsFacadeMock.trackEventWasCalled).to(beCalledOnce())
                    expect(analyticsFacadeMock.trackEventReceivedEvent).to(equal(TestData.Debit.event))
                }
            }
        }

        describe(".trackButtonTap") {
            context("when debit installment") {
                it("should track button") {
                    // given
                    analytics = InstalmentDetailAnalytics(analyticsFacade: analyticsFacadeMock, installmentType: .debit)
                    // when
                    analytics.trackButtonTap()
                    // then
                    expect(analyticsFacadeMock.trackEventWasCalled).to(beCalledOnce())
                    expect(analyticsFacadeMock.trackEventReceivedEvent).to(equal(TestData.Debit.buttonEvent))
                }
            }
            context("when credit installment") {
                it("should track button") {
                    // given
                    analytics = InstalmentDetailAnalytics(analyticsFacade: analyticsFacadeMock, installmentType: .credit)
                    // when
                    analytics.trackButtonTap()
                    // then
                    expect(analyticsFacadeMock.trackEventWasCalled).to(beCalledOnce())
                    expect(analyticsFacadeMock.trackEventReceivedEvent).to(equal(TestData.Credit.buttonEvent))
                }
            }
            context("when promotion installment") {
                it("should track button") {
                    // given
                    analytics = InstalmentDetailAnalytics(analyticsFacade: analyticsFacadeMock, installmentType: .promotional)
                    // when
                    analytics.trackButtonTap()
                    // then
                    expect(analyticsFacadeMock.trackEventWasCalled).to(beCalledOnce())
                    expect(analyticsFacadeMock.trackEventReceivedEvent).to(equal(TestData.Debit.buttonEvent))
                }
            }
        }
    }
}

private extension InstalmentDetailAnalyticsTests {
    enum TestData {
        enum Credit {
            static let creditScreenOpened = "Credit Installment Details Screen Opened"
            static let creditScreenName = "Credit Installment Details Screen"
            static let creditButtonClick = "Credit Installment Early Repayment Button Click"

            static let event = AnalyticsEvent(
                category: category,
                action: impressionAction,
                label: creditScreenOpened,
                screenName: creditScreenName
            )

            static let buttonEvent = AnalyticsEvent(
                category: category,
                action: cklickAction,
                label: creditButtonClick,
                screenName: creditScreenName
            )
        }

        enum Debit {
            static let debitScreenOpened = "Debit Installment Details Screen Opened"
            static let debitScreenName = "Debit Installment Details Screen"
            static let debitButtonClick = "Debit Installment Early Repayment Button Click"

            static let event = AnalyticsEvent(
                category: category,
                action: impressionAction,
                label: debitScreenOpened,
                screenName: debitScreenName
            )

            static let buttonEvent = AnalyticsEvent(
                category: category,
                action: cklickAction,
                label: debitButtonClick,
                screenName: debitScreenName
            )
        }

        static let category = "Installment"
        static let impressionAction: EventAction = .impression
        static let cklickAction: EventAction = .click
    }
}
