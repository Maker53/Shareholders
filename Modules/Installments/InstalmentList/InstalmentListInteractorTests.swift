//  Created by Lyudmila Danilchenko on 17/08/2020.

import AMSharedProtocolsAndModels
import NetworkKit
import Resources
import SharedPromiseKit
import TestAdditions

// swiftlint:disable file_length

@testable import Installments

final class InstalmentListInteractorTests: QuickSpec {
    override func spec() {
        var interactor: InstalmentListInteractor!
        var presenterMock: InstalmentListPresentationLogicMock!
        var providerMock: ProvidesInstalmentListMock!
        var featuresServiceMock: FeaturesServiceMock!

        beforeEach {
            presenterMock = InstalmentListPresentationLogicMock()
            providerMock = ProvidesInstalmentListMock()
            featuresServiceMock = .init()
            interactor = InstalmentListInteractor(
                presenter: presenterMock,
                provider: providerMock,
                featuresService: featuresServiceMock
            )

            featuresServiceMock.anySpecifiedEnabledFeatures = [
                .extra(AMSharedFeature.debitInstallment.rawValue),
                .extra(AMSharedFeature.creditCardsPlanIt.rawValue),
            ]
        }

        describe(".openInstallmentDetails") {
            context("when success") {
                context("when one installment") {
                    it("should ask presenter to present installment details") {
                        // given
                        providerMock.getInstalmentsUsingCacheCreditStub = TestData.InstallmentDetails.oneInstallmentStub
                        // when
                        interactor.openInstallmentDetails(TestData.InstallmentDetails.request)
                        // then
                        expect(providerMock.getInstalmentsUsingCacheWasCalled).to(beCalledOnce())
                        expect(providerMock.getInstalmentsUsingCacheReceivedUsingCache).to(beTrue())
                        expect(providerMock.getInstalmentsUsingCacheReceivedInstallmentType)
                            .to(equal([TestData.InstallmentDetails.request.installmentType]))

                        expect(presenterMock.presentInstallmentDetailsWasCalled).toEventually(beCalledOnce())
                        expect(presenterMock.presentInstallmentDetailsReceivedResponse)
                            .toEventually(equal(TestData.InstallmentDetails.oneExpectedResponse))
                    }
                }
                context("when more than one installment") {
                    it("should ask presenter to present installment details") {
                        // given
                        providerMock.getInstalmentsUsingCacheCreditStub = TestData.InstallmentDetails.severalInstallmentStub
                        // when
                        interactor.openInstallmentDetails(TestData.InstallmentDetails.request)
                        // then
                        expect(providerMock.getInstalmentsUsingCacheWasCalled).to(beCalledOnce())
                        expect(providerMock.getInstalmentsUsingCacheReceivedUsingCache).to(beTrue())
                        expect(providerMock.getInstalmentsUsingCacheReceivedInstallmentType)
                            .to(equal([TestData.InstallmentDetails.request.installmentType]))

                        expect(presenterMock.presentInstallmentDetailsWasCalled).toEventually(beCalledOnce())
                        expect(presenterMock.presentInstallmentDetailsReceivedResponse)
                            .toEventually(equal(TestData.InstallmentDetails.severalExpectedResponse))
                    }
                }
            }

            context("when failure") {
                it("should ask presenter to present error") {
                    // given
                    providerMock.getInstalmentsUsingCacheCreditStub = TestData.InstallmentDetails.errorStub
                    // when
                    interactor.openInstallmentDetails(TestData.InstallmentDetails.request)
                    // then
                    expect(providerMock.getInstalmentsUsingCacheWasCalled).to(beCalledOnce())
                    expect(providerMock.getInstalmentsUsingCacheReceivedUsingCache).to(beTrue())
                    expect(providerMock.getInstalmentsUsingCacheReceivedInstallmentType)
                        .to(equal([TestData.InstallmentDetails.request.installmentType]))

                    expect(presenterMock.presentErrorWasCalled).toEventually(beCalledOnce())
                    expect(presenterMock.presentErrorReceivedResponse)
                        .toEventually(equal(.init(description: Resources.L10n.APIClientError.somethingWentWrong)))
                }
            }
        }

        describe(".openNewInstalment") {
            context("when .debitInstallment enabled") {
                it("should ask provider to get debit offers") {
                    // given
                    featuresServiceMock.anySpecifiedEnabledFeatures = [.extra(AMSharedFeature.debitInstallment.rawValue)]
                    providerMock.getInstalmentOffersDebitStub = .value(TestData.offerResponse)
                    // when
                    interactor.openNewInstalment()
                    // then
                    expect(providerMock.getInstalmentOffersWasCalled).to(beCalledOnce())
                    expect(providerMock.getInstalmentOffersContextReceivedContext)
                        .to(equal([.init(installmentType: .debit, operationID: nil)]))
                }
            }
            context("when .creditCardsPlanIt enabled") {
                it("should ask provider to get credit offers") {
                    // given
                    featuresServiceMock.anySpecifiedEnabledFeatures = [.extra(AMSharedFeature.creditCardsPlanIt.rawValue)]
                    providerMock.getInstalmentOffersCreditStub = .value(TestData.offerResponse)
                    // when
                    interactor.openNewInstalment()
                    // then
                    expect(providerMock.getInstalmentOffersWasCalled).to(beCalledOnce())
                    expect(providerMock.getInstalmentOffersContextReceivedContext)
                        .to(equal([.init(installmentType: .credit, operationID: nil)]))
                }
            }
            context("when FT is disabled") {
                it("should not ask provider to get offers") {
                    // given
                    featuresServiceMock.specifiedEnabledFeatures = []
                    providerMock.getInstalmentOffersCreditStub = .value(TestData.offerResponse)
                    // when
                    interactor.openNewInstalment()
                    // then
                    expect(providerMock.getInstalmentOffersWasCalled).toNot(beCalled())
                }
            }
            context("when there is succsessful offer response") {
                it("should ask presenter to present new instalment if provider have cachedOffers") {
                    // given
                    providerMock.getInstalmentOffersCreditStub = .value(TestData.offerResponse)
                    providerMock.getInstalmentOffersDebitStub = .value(TestData.offerResponse)
                    // when
                    interactor.openNewInstalment()
                    // then
                    expect(providerMock.getInstalmentOffersWasCalled).to(equal(2))
                    expect(providerMock.getInstalmentOffersContextReceivedContext).to(equal(TestData.receivedContexts))
                    expect(presenterMock.presentNewInstalmentWasCalled).toEventually(beCalledOnce())
                    expect(presenterMock.presentNewInstalmentReceivedResponse)
                        .toEventually(equal(TestData.newInstallmentResponse))
                }
            }
            context("when there is error offer response") {
                it("should ask presenter to present error") {
                    // given
                    let error = ServiceError.other
                    providerMock.getInstalmentOffersCreditStub = .init(error: error)
                    providerMock.getInstalmentOffersDebitStub = .init(error: error)
                    // when
                    interactor.openNewInstalment()
                    // then
                    expect(providerMock.getInstalmentOffersWasCalled).to(equal(2))
                    expect(providerMock.getInstalmentOffersContextReceivedContext).to(equal(TestData.receivedContexts))
                    expect(presenterMock.presentErrorWasCalled).toEventually(beCalledOnce())
                    expect(presenterMock.presentErrorReceivedResponse)
                        .toEventually(equal(.init(description: Resources.L10n.APIClientError.somethingWentWrong)))
                }
            }
        }

        describe(".init") {
            it("should configure interactor") {
                // then
                expect(interactor.presenter).to(beIdenticalTo(presenterMock))
            }
        }

        describe(".loadData") {
            context(".creditCardsPlanIt and .creditCardsPlanIt features") {
                context("when both disabled") {
                    it("should not request offers and installments") {
                        // given
                        featuresServiceMock.specifiedEnabledFeatures = []
                        providerMock.getInstalmentOffersDebitStub = TestData.offerSuccessResponse
                        providerMock.getInstalmentOffersCreditStub = TestData.offerSuccessResponse
                        providerMock.getInstalmentsUsingCacheDebitStub = TestData.providerSuccessResponse
                        providerMock.getInstalmentsUsingCacheCreditStub = TestData.providerSuccessResponse

                        // when
                        interactor.loadData(.init(shouldRefreshInstalments: true))
                        // then
                        expect(providerMock.getInstalmentOffersContextReceivedContext).to(equal(TestData.receivedContextsTypesNoFT))
                        expect(providerMock.getInstalmentsUsingCacheReceivedInstallmentType)
                            .to(equal(TestData.receivedInstallmentTypesNoFT))
                        expect(presenterMock.presentEmptyStateWasCalled)
                            .toEventually(beCalledOnce())
                        expect(presenterMock.presentEmptyStateReceivedResponse?.offersState)
                            .to(equal([]))
                    }
                }
                context("when credit enabled") {
                    it("should request credit offers and credit installments") {
                        // given
                        featuresServiceMock.anySpecifiedEnabledFeatures = [.extra(AMSharedFeature.creditCardsPlanIt.rawValue)]
                        providerMock.getInstalmentOffersDebitStub = TestData.offerSuccessResponse
                        providerMock.getInstalmentOffersCreditStub = TestData.offerSuccessResponse
                        providerMock.getInstalmentsUsingCacheDebitStub = TestData.providerSuccessResponse
                        providerMock.getInstalmentsUsingCacheCreditStub = TestData.providerSuccessResponse

                        // when
                        interactor.loadData(.init(shouldRefreshInstalments: true))

                        // then
                        expect(providerMock.getInstalmentsUsingCacheReceivedUsingCache).to(beFalse())
                        expect(providerMock.getInstalmentOffersContextReceivedContext).to(equal(TestData.receivedContextsCredit))
                        expect(providerMock.getInstalmentsUsingCacheReceivedInstallmentType)
                            .to(equal(TestData.receivedInstallmentTypesCredit))
                        expect(presenterMock.presentInstalmentListWasCalled).toEventually(beCalledOnce())
                        expect(presenterMock.presentInstalmentListReceivedResponse)
                            .toEventually(equal(TestData.installmentListCreditResponse))
                    }
                }
            }
            context("when debit enabled") {
                it("should request only debit offers and installments") {
                    // given
                    featuresServiceMock.anySpecifiedEnabledFeatures = [.extra(AMSharedFeature.debitInstallment.rawValue)]
                    providerMock.getInstalmentOffersDebitStub = TestData.offerSuccessResponse
                    providerMock.getInstalmentOffersCreditStub = TestData.offerSuccessResponse
                    providerMock.getInstalmentsUsingCacheDebitStub = TestData.providerSuccessResponse
                    providerMock.getInstalmentsUsingCacheCreditStub = TestData.providerSuccessResponse

                    // when
                    interactor.loadData(.init(shouldRefreshInstalments: true))
                    // then
                    expect(providerMock.getInstalmentOffersContextReceivedContext).to(equal(TestData.receivedContextsDebit))
                    expect(providerMock.getInstalmentsUsingCacheReceivedInstallmentType).to(equal(TestData.receivedInstallmentTypesDebit))
                    expect(presenterMock.presentInstalmentListWasCalled).toEventually(beCalledOnce())
                    expect(presenterMock.presentInstalmentListReceivedResponse).toEventually(equal(TestData.installmentListDebitResponse))
                }
            }
            context("when called with shouldRefreshInstalments: true") {
                it("should call provider.getNewInstalments") {
                    // given
                    providerMock.getInstalmentOffersDebitStub = TestData.offerSuccessResponse
                    providerMock.getInstalmentOffersCreditStub = TestData.offerSuccessResponse
                    providerMock.getInstalmentsUsingCacheDebitStub = TestData.providerSuccessResponse
                    providerMock.getInstalmentsUsingCacheCreditStub = TestData.providerSuccessResponse

                    // when
                    interactor.loadData(.init(shouldRefreshInstalments: true))

                    // then
                    expect(providerMock.getInstalmentsUsingCacheReceivedUsingCache).to(beFalse())
                    expect(providerMock.getInstalmentOffersContextReceivedContext).to(equal(TestData.receivedContexts))
                    expect(providerMock.getInstalmentsUsingCacheReceivedInstallmentType).to(equal(TestData.receivedInstallmentTypes))
                }
            }

            context("when called with shouldRefreshInstalments: false") {
                it("should call provider.getInstalments") {
                    // given
                    providerMock.getInstalmentOffersDebitStub = TestData.offerSuccessResponse
                    providerMock.getInstalmentOffersCreditStub = TestData.offerSuccessResponse
                    providerMock.getInstalmentsUsingCacheDebitStub = TestData.providerSuccessResponse
                    providerMock.getInstalmentsUsingCacheCreditStub = TestData.providerSuccessResponse

                    // when
                    interactor.loadData(.init(shouldRefreshInstalments: false))

                    // then
                    expect(providerMock.getInstalmentsUsingCacheReceivedUsingCache).to(beTrue())
                    expect(providerMock.getInstalmentOffersContextReceivedContext).to(equal(TestData.receivedContexts))
                    expect(providerMock.getInstalmentsUsingCacheReceivedInstallmentType).to(equal(TestData.receivedInstallmentTypes))
                }
            }

            context("when instalmentOffers succeeded") {
                context("when offers are not empty") {
                    it("should ask presenter to present Plus Button") {
                        // given
                        providerMock.getInstalmentOffersDebitStub = TestData.offerSuccessResponse
                        providerMock.getInstalmentOffersCreditStub = TestData.offerSuccessResponse
                        providerMock.getInstalmentsUsingCacheDebitStub = TestData.providerSuccessResponse
                        providerMock.getInstalmentsUsingCacheCreditStub = TestData.providerSuccessResponse

                        // when
                        interactor.loadData(.init(shouldRefreshInstalments: false))
                        // then
                        expect(presenterMock.presentPlusButtonWasCalled)
                            .toEventually(beCalledOnce())
                        expect(presenterMock.presentPlusButtonReceivedResponse?.shouldPresentButton).to(beTrue())
                        expect(providerMock.getInstalmentOffersContextReceivedContext).to(equal(TestData.receivedContexts))
                        expect(providerMock.getInstalmentsUsingCacheReceivedInstallmentType).to(equal(TestData.receivedInstallmentTypes))
                    }
                    it("should ask presenter to present Plus Button") {
                        // given
                        providerMock.getInstalmentOffersDebitStub = TestData.offerSuccessResponse
                        providerMock.getInstalmentOffersCreditStub = TestData.Empty.offerSuccessResponse
                        providerMock.getInstalmentsUsingCacheDebitStub = TestData.providerSuccessResponse
                        providerMock.getInstalmentsUsingCacheCreditStub = TestData.providerSuccessResponse

                        // when
                        interactor.loadData(.init(shouldRefreshInstalments: false))
                        // then
                        expect(presenterMock.presentPlusButtonWasCalled)
                            .toEventually(beCalledOnce())
                        expect(presenterMock.presentPlusButtonReceivedResponse?.shouldPresentButton).to(beTrue())
                        expect(providerMock.getInstalmentOffersContextReceivedContext).to(equal(TestData.receivedContexts))
                        expect(providerMock.getInstalmentsUsingCacheReceivedInstallmentType).to(equal(TestData.receivedInstallmentTypes))
                    }
                    it("should ask presenter to present Plus Button") {
                        // given
                        providerMock.getInstalmentOffersDebitStub = TestData.Empty.offerSuccessResponse
                        providerMock.getInstalmentOffersCreditStub = TestData.offerSuccessResponse
                        providerMock.getInstalmentsUsingCacheDebitStub = TestData.providerSuccessResponse
                        providerMock.getInstalmentsUsingCacheCreditStub = TestData.providerSuccessResponse

                        // when
                        interactor.loadData(.init(shouldRefreshInstalments: false))
                        // then
                        expect(presenterMock.presentPlusButtonWasCalled)
                            .toEventually(beCalledOnce())
                        expect(presenterMock.presentPlusButtonReceivedResponse?.shouldPresentButton).to(beTrue())
                        expect(providerMock.getInstalmentOffersContextReceivedContext).to(equal(TestData.receivedContexts))
                        expect(providerMock.getInstalmentsUsingCacheReceivedInstallmentType).to(equal(TestData.receivedInstallmentTypes))
                    }
                }

                context("when offers are empty") {
                    it("should ask presenter to hide Plus Button") {
                        // given
                        providerMock.getInstalmentOffersDebitStub = TestData.Empty.offerSuccessResponse
                        providerMock.getInstalmentOffersCreditStub = TestData.Empty.offerSuccessResponse
                        providerMock.getInstalmentsUsingCacheDebitStub = TestData.providerSuccessResponse
                        providerMock.getInstalmentsUsingCacheCreditStub = TestData.providerSuccessResponse

                        // when
                        interactor.loadData(.init(shouldRefreshInstalments: false))
                        // then
                        expect(presenterMock.presentPlusButtonWasCalled)
                            .toEventually(beCalledOnce())
                        expect(presenterMock.presentPlusButtonReceivedResponse?.shouldPresentButton).to(beFalse())
                        expect(providerMock.getInstalmentOffersContextReceivedContext).to(equal(TestData.receivedContexts))
                        expect(providerMock.getInstalmentsUsingCacheReceivedInstallmentType).to(equal(TestData.receivedInstallmentTypes))
                    }
                }

                context("when loadInstalments succeeded") {
                    it("should ask presenter to present result") {
                        // given
                        providerMock.getInstalmentOffersDebitStub = TestData.offerSuccessResponse
                        providerMock.getInstalmentOffersCreditStub = TestData.offerSuccessResponse
                        providerMock.getInstalmentsUsingCacheDebitStub = TestData.providerSuccessResponse
                        providerMock.getInstalmentsUsingCacheCreditStub = TestData.providerSuccessResponse

                        // when
                        interactor.loadData(.init(shouldRefreshInstalments: false))
                        // then
                        expect(presenterMock.presentInstalmentListWasCalled)
                            .toEventually(beCalledOnce())
                        expect(presenterMock.presentInstalmentListReceivedResponse)
                            .toEventually(equal(TestData.response))
                        expect(providerMock.getInstalmentOffersContextReceivedContext).to(equal(TestData.receivedContexts))
                        expect(providerMock.getInstalmentsUsingCacheReceivedInstallmentType).to(equal(TestData.receivedInstallmentTypes))
                    }
                }

                context("when instalments empty and offers empty") {
                    beforeEach {
                        // given
                        providerMock.getInstalmentOffersDebitStub = TestData.Empty.offerSuccessResponse
                        providerMock.getInstalmentOffersCreditStub = TestData.Empty.offerSuccessResponse
                        providerMock.getInstalmentsUsingCacheDebitStub = TestData.Empty.providerSuccessResponse
                        providerMock.getInstalmentsUsingCacheCreditStub = TestData.Empty.providerSuccessResponse
                    }
                    it("should ask presenter present empty view") {
                        // when
                        interactor.loadData(.init(shouldRefreshInstalments: false))
                        // then
                        expect(presenterMock.presentEmptyStateWasCalled).toEventually(beCalledOnce())
                        expect(presenterMock.presentEmptyStateReceivedResponse)
                            .toEventually(equal(.init(offersState: [])))
                        expect(providerMock.getInstalmentOffersContextReceivedContext).to(equal(TestData.receivedContexts))
                        expect(providerMock.getInstalmentsUsingCacheReceivedInstallmentType).to(equal(TestData.receivedInstallmentTypes))
                    }

                    it("shouldn't show plus button") {
                        // when
                        interactor.loadData(.init(shouldRefreshInstalments: false))
                        // then
                        expect(presenterMock.presentPlusButtonWasCalled).toEventually(beCalledOnce())
                        expect(presenterMock.presentPlusButtonReceivedResponse?.shouldPresentButton).to(beFalse())
                    }
                }

                context("when instalments empty and offers are not empty") {
                    beforeEach {
                        // given
                        providerMock.getInstalmentOffersDebitStub = TestData.offerSuccessResponse
                        providerMock.getInstalmentOffersCreditStub = TestData.offerSuccessResponse
                        providerMock.getInstalmentsUsingCacheDebitStub = TestData.Empty.providerSuccessResponse
                        providerMock.getInstalmentsUsingCacheCreditStub = TestData.Empty.providerSuccessResponse
                    }
                    it("should ask presenter present empty view") {
                        // when
                        interactor.loadData(.init(shouldRefreshInstalments: false))
                        // then
                        expect(presenterMock.presentEmptyStateWasCalled)
                            .toEventually(beCalledOnce())
                        expect(presenterMock.presentEmptyStateReceivedResponse)
                            .toEventually(equal(.init(offersState: [.hasCreditOffer, .hasDebitOffer])))
                        expect(providerMock.getInstalmentOffersContextReceivedContext).to(equal(TestData.receivedContexts))
                        expect(providerMock.getInstalmentsUsingCacheReceivedInstallmentType).to(equal(TestData.receivedInstallmentTypes))
                    }

                    it("should show plus button") {
                        // when
                        interactor.loadData(.init(shouldRefreshInstalments: false))
                        // then
                        expect(presenterMock.presentPlusButtonWasCalled)
                            .toEventually(beCalledOnce())
                        expect(presenterMock.presentPlusButtonReceivedResponse?.shouldPresentButton).to(beTrue())
                        expect(providerMock.getInstalmentOffersContextReceivedContext).to(equal(TestData.receivedContexts))
                        expect(providerMock.getInstalmentsUsingCacheReceivedInstallmentType).to(equal(TestData.receivedInstallmentTypes))
                    }
                }

                context("when instalments and debit offers are empty and credit offers are not empty") {
                    beforeEach {
                        // given
                        providerMock.getInstalmentOffersDebitStub = TestData.Empty.offerSuccessResponse
                        providerMock.getInstalmentOffersCreditStub = TestData.offerSuccessResponse
                        providerMock.getInstalmentsUsingCacheDebitStub = TestData.Empty.providerSuccessResponse
                        providerMock.getInstalmentsUsingCacheCreditStub = TestData.Empty.providerSuccessResponse
                    }
                    it("should ask presenter present empty view") {
                        // when
                        interactor.loadData(.init(shouldRefreshInstalments: false))
                        // then
                        expect(presenterMock.presentEmptyStateWasCalled)
                            .toEventually(beCalledOnce())
                        expect(presenterMock.presentEmptyStateReceivedResponse)
                            .toEventually(equal(.init(offersState: [.hasCreditOffer])))
                        expect(providerMock.getInstalmentOffersContextReceivedContext)
                            .to(equal(TestData.receivedContexts))
                        expect(providerMock.getInstalmentsUsingCacheReceivedInstallmentType)
                            .to(equal(TestData.receivedInstallmentTypes))
                    }

                    it("should show plus button") {
                        // when
                        interactor.loadData(.init(shouldRefreshInstalments: false))
                        // then
                        expect(presenterMock.presentPlusButtonWasCalled)
                            .toEventually(beCalledOnce())
                        expect(presenterMock.presentPlusButtonReceivedResponse?.shouldPresentButton).to(beTrue())
                        expect(providerMock.getInstalmentOffersContextReceivedContext).to(equal(TestData.receivedContexts))
                        expect(providerMock.getInstalmentsUsingCacheReceivedInstallmentType).to(equal(TestData.receivedInstallmentTypes))
                    }
                }

                context("when instalments and credit offers are empty and debit offers are not empty") {
                    beforeEach {
                        // given
                        providerMock.getInstalmentOffersDebitStub = TestData.offerSuccessResponse
                        providerMock.getInstalmentOffersCreditStub = TestData.Empty.offerSuccessResponse
                        providerMock.getInstalmentsUsingCacheDebitStub = TestData.Empty.providerSuccessResponse
                        providerMock.getInstalmentsUsingCacheCreditStub = TestData.Empty.providerSuccessResponse
                    }
                    it("should ask presenter present empty view") {
                        // when
                        interactor.loadData(.init(shouldRefreshInstalments: false))
                        // then
                        expect(presenterMock.presentEmptyStateWasCalled)
                            .toEventually(beCalledOnce())
                        expect(presenterMock.presentEmptyStateReceivedResponse)
                            .toEventually(equal(.init(offersState: [.hasDebitOffer])))
                        expect(providerMock.getInstalmentOffersContextReceivedContext)
                            .to(equal(TestData.receivedContexts))
                        expect(providerMock.getInstalmentsUsingCacheReceivedInstallmentType)
                            .to(equal(TestData.receivedInstallmentTypes))
                    }

                    it("should show plus button") {
                        // when
                        interactor.loadData(.init(shouldRefreshInstalments: false))
                        // then
                        expect(presenterMock.presentPlusButtonWasCalled)
                            .toEventually(beCalledOnce())
                        expect(presenterMock.presentPlusButtonReceivedResponse?.shouldPresentButton).to(beTrue())
                        expect(providerMock.getInstalmentOffersContextReceivedContext).to(equal(TestData.receivedContexts))
                        expect(providerMock.getInstalmentsUsingCacheReceivedInstallmentType).to(equal(TestData.receivedInstallmentTypes))
                    }
                }

                context("when loadInstalments and loadOffers failed") {
                    it("should ask presenter to present error") {
                        // given
                        providerMock.getInstalmentOffersDebitStub = TestData.offerFailureResponse
                        providerMock.getInstalmentOffersCreditStub = TestData.offerFailureResponse
                        providerMock.getInstalmentsUsingCacheDebitStub = TestData.providerFailureResponse
                        providerMock.getInstalmentsUsingCacheCreditStub = TestData.providerFailureResponse

                        // when
                        interactor.loadData(.init(shouldRefreshInstalments: false))
                        // then
                        expect(presenterMock.presentErrorWasCalled)
                            .toEventually(beCalledOnce())
                        expect(presenterMock.presentErrorReceivedResponse?.description)
                            .toEventually(equal(TestData.errorMessage))
                        expect(providerMock.getInstalmentOffersContextReceivedContext).to(equal(TestData.receivedContexts))
                        expect(providerMock.getInstalmentsUsingCacheReceivedInstallmentType).to(equal(TestData.receivedInstallmentTypes))
                    }
                }

                context("when loadOffers failed") {
                    it("should not ask presenter to present error") {
                        // given
                        providerMock.getInstalmentsUsingCacheDebitStub = TestData.providerSuccessResponse
                        providerMock.getInstalmentsUsingCacheCreditStub = TestData.providerSuccessResponse
                        providerMock.getInstalmentOffersDebitStub = TestData.offerFailureResponse
                        providerMock.getInstalmentOffersCreditStub = TestData.offerFailureResponse

                        // when
                        interactor.loadData(.init(shouldRefreshInstalments: false))
                        // then
                        expect(presenterMock.presentErrorWasCalled).toEventually(beCalledOnce())
                        expect(presenterMock.presentErrorReceivedResponse)
                            .toEventually(equal(.init(description: TestData.defaultError.localizedDescription)))
                        expect(providerMock.getInstalmentOffersContextReceivedContext).to(equal(TestData.receivedContexts))
                        expect(providerMock.getInstalmentsUsingCacheReceivedInstallmentType).to(equal(TestData.receivedInstallmentTypes))
                    }
                }
            }
        }
    }
}

private extension InstalmentListInteractorTests {
    enum TestData {
        enum InstallmentDetails {
            static let error = ServiceError.other
            static let errorStub: Promise<[Instalment]> = .init(error: error)
            static let request = InstalmentList.PresentInstallmentDetails.Request(
                installment: Instalment.Seeds.value,
                installmentType: .credit
            )
            static let oneInstallment = [Instalment.Seeds.value]
            static let severalInstallments = [Instalment.Seeds.value, Instalment.Seeds.value]
            static let oneInstallmentStub: Promise<[Instalment]> = .value(oneInstallment)
            static let severalInstallmentStub: Promise<[Instalment]> = .value(severalInstallments)
            static let oneExpectedResponse = InstallmentDetailsContext.full(
                InstallmentDetailsModel(
                    installment: Instalment.Seeds.value,
                    installmentType: .credit,
                    isSeveralInstallments: false
                )
            )
            static let severalExpectedResponse = InstallmentDetailsContext.full(
                InstallmentDetailsModel(
                    installment: Instalment.Seeds.value,
                    installmentType: .credit,
                    isSeveralInstallments: true
                )
            )
        }

        enum Empty {
            static let value: [Instalment] = []
            static let model = InstalmentListResponse(instalments: Empty.value)
            static let providerSuccessResponse = Promise.value(Empty.value)
            static let offerSuccessResponse = Promise.value(InstalmentOfferResponse.Seeds.emptyValue)
        }

        static let value = [Instalment.Seeds.value]
        static let creditValue = value
        static let debitValue = value
        static let model = InstalmentListResponse(instalments: creditValue + debitValue)
        static let providerSuccessResponse = Promise.value(value)
        static let providerFailureResponse: Promise<[Instalment]> = .init(error: TestData.serviceError)
        static let expectedPayment = Amount(3_267_964, minorUnits: 100, currency: .rub)
        static let expectedPaymentNoFT = Amount(1_633_982, minorUnits: 100, currency: .rub)
        static let response = InstalmentList.PresentModuleData.Response(
            paymentSum: expectedPayment,
            creditInstallments: creditValue,
            debitInstallments: debitValue
        )
        static let responseNoFT = InstalmentList.PresentModuleData.Response(
            paymentSum: .zero,
            creditInstallments: [],
            debitInstallments: []
        )
        static let errorMessage = "errorMessage"
        static let serviceError = ServiceError.requestFailed(message: errorMessage)
        static let errorText = Resources.L10n.APIClientError.somethingWentWrong
        static let defaultError = ServiceError.requestFailed(message: errorText)
        static let offerSuccessResponse = Promise.value(InstalmentOfferResponse.Seeds.value)
        static let offerResponse = InstalmentOfferResponse.Seeds.value
        static let offerFailureResponse: Promise<InstalmentOfferResponse> = .init(error: TestData.defaultError)
        static let wrongOffer = InstalmentOffer(
            id: "678",
            account: .default(AccountWithCards.Seeds.defaultAccount),
            hasInstallmentBaseAgreement: false,
            offerType: .standard,
            banner: nil
        )
        static let offersValue = [InstalmentOffer.Seeds.value, InstalmentOffer.Seeds.value]
        static let creditOffers = offersValue
        static let debitOffers = offersValue
        static let offers = creditOffers + debitOffers
        static let receivedInstallmentTypes: [InstallmentType] = [.debit, .credit]
        static let receivedInstallmentTypesCredit: [InstallmentType] = [.credit]
        static let receivedContexts: [InstallmentOfferContext] = [
            .init(installmentType: .debit, operationID: nil), .init(installmentType: .credit, operationID: nil),
        ]
        static let receivedContextsCredit: [InstallmentOfferContext] = [.init(installmentType: .credit, operationID: nil)]
        static let receivedContextsDebit: [InstallmentOfferContext] = [.init(installmentType: .debit, operationID: nil)]
        static let receivedInstallmentTypesDebit: [InstallmentType] = [.debit]
        static let receivedContextsTypesNoFT: [InstallmentOfferContext] = []
        static let receivedInstallmentTypesNoFT: [InstallmentType] = []
        static let newInstallmentResponse = InstalmentList.PresentNewInstalmentData.Response(
            creditOffers: offerResponse,
            debitOffers: offerResponse
        )
        static let installmentListCreditResponse = InstalmentList.PresentModuleData.Response(
            paymentSum: expectedPaymentNoFT,
            creditInstallments: creditValue,
            debitInstallments: []
        )
        static let installmentListDebitResponse = InstalmentList.PresentModuleData.Response(
            paymentSum: expectedPaymentNoFT,
            creditInstallments: [],
            debitInstallments: debitValue
        )
    }
}
