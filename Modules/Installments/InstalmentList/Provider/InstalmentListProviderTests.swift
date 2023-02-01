//  Created by Lyudmila Danilchenko on 10.09.2020.

import AlfaFoundation
import AlfaNetworking
import NetworkKit
import TestAdditions

@testable import Installments

final class InstalmentListProviderTests: QuickSpec {
    override func spec() {
        var serviceMock: NetworkServiceMock<[Instalment], Void, InstallmentType, ServiceError>!
        var serviceOfferMock: NetworkServiceMock<InstalmentOfferResponse, Void, InstallmentOfferContext, ServiceError>!
        var dataStoreMock: StoresInstalmentListMock!
        var provider: InstalmentListProvider!

        beforeEach {
            serviceMock = .init()
            serviceOfferMock = .init()
            dataStoreMock = StoresInstalmentListMock()
            provider = InstalmentListProvider(
                dataStore: dataStoreMock,
                service: serviceMock,
                serviceOffer: serviceOfferMock
            )
            dataStoreMock.instalmentOffersModelWithTypeStub = [
                .credit: nil,
                .debit: nil,
            ]
            dataStoreMock.instalmentListModelWithTypeStub = [
                .credit: nil,
                .debit: nil,
            ]
        }

        describe(".getInstalments") {
            context("when usingCache is true") {
                it("should try to use cache") {
                    // given
                    dataStoreMock.instalmentListModelWithTypeStub = [.credit: TestData.model]
                    // when
                    _ = provider.getInstalments(installmentType: .credit, usingCache: true)
                    // then
                    expect(dataStoreMock.getInstalmentListModelWithTypeWasCalled).to(beCalledOnce())
                    expect(dataStoreMock.instalmentListModelWithType[.credit]).to(equal(TestData.model))
                    expect(serviceMock.sendRequestWasCalled).toNot(beCalled())
                }
            }

            context("when usingCache is false") {
                it("should not try to use cache") {
                    // when
                    _ = provider.getInstalments(installmentType: .credit, usingCache: false)

                    // then
                    expect(dataStoreMock.getInstalmentListModelWithTypeWasCalled).toNot(beCalled())
                    expect(serviceMock.sendRequestWasCalled).toEventually(beCalledOnce())
                }
            }

            context("when dataStore contains responseModel") {
                it("should return responseModel from dataStore") {
                    // given
                    dataStoreMock.instalmentListModelWithTypeStub = [.credit: TestData.model]
                    // when
                    _ = provider.getInstalments(installmentType: .credit)
                    // then
                    expect(serviceMock.sendRequestWasCalled).toNot(beCalled())
                }
            }

            context("when dataStore missing responseModel") {
                it("should call service") {
                    // given
                    dataStoreMock.instalmentListModelWithTypeStub = [.credit: nil]
                    // when
                    _ = provider.getInstalments(installmentType: .credit)
                    // then
                    expect(serviceMock.sendRequestWasCalled).toEventually(beCalledOnce())
                }
            }

            context("when successful response") {
                it("should store responseModel") {
                    // given
                    serviceMock.sendRequestCompletionStub = .success(TestData.model.instalments)
                    // when
                    let result = provider.getInstalments(installmentType: .credit)
                    // then
                    expect(dataStoreMock.instalmentListModelWithType[.credit]??.instalments).toEventually(equal(TestData.model.instalments))
                    expect(result.isFulfilled).toEventually(beTrue())
                }
            }

            context("when failure response") {
                it("should return error") {
                    // given
                    let error: ServiceError = .other
                    serviceMock.sendRequestCompletionStub = .failure(error)
                    // when
                    let result = provider.getInstalments(installmentType: .credit)
                    // then
                    expect(result.error).toEventually(matchError(error))
                }
            }
        }

        describe(".getInstalmentsOffers") {
            context("when dataStore contains responseModel") {
                it("should return responseModel from dataStore") {
                    // given
                    dataStoreMock.instalmentOffersModelWithTypeStub = [.credit: TestData.offerModel]
                    // when
                    _ = provider.getInstalmentOffers(context: TestData.defaultContext)
                    // then
                    expect(dataStoreMock.getInstalmentListOffersModelWithTypeWasCalled).to(beCalledOnce())
                    expect(serviceOfferMock.sendRequestWasCalled).toNot(beCalled())
                }
            }

            context("when dataStore missing responseModel") {
                it("should call service") {
                    // given
                    dataStoreMock.instalmentOffersModelWithTypeStub = [.credit: nil]
                    // when
                    _ = provider.getInstalmentOffers(context: TestData.defaultContext)
                    // then
                    expect(serviceOfferMock.sendRequestWasCalled).toEventually(beCalledOnce())
                    expect(serviceOfferMock.sendRequestReceivedArguments?.pathContext).to(equal(TestData.defaultContext))
                }
            }

            context("when successful response") {
                it("should store responseModel") {
                    // given
                    serviceOfferMock.sendRequestCompletionStub = .success(TestData.offerModel)
                    // when
                    let result = provider.getInstalmentOffers(context: TestData.defaultContext)
                    // then
                    expect(dataStoreMock?.instalmentOffersModelWithType[.credit]??.instalmentOffers)
                        .toEventually(equal(TestData.offerModel.instalmentOffers))
                    expect(serviceOfferMock.sendRequestReceivedArguments?.pathContext).to(equal(TestData.defaultContext))
                    expect(result.isFulfilled).toEventually(beTrue())
                }
            }

            context("when failure response") {
                it("should return error") {
                    // given
                    let error: ServiceError = .other
                    serviceOfferMock.sendRequestCompletionStub = .failure(error)
                    // when
                    let result = provider.getInstalmentOffers(context: TestData.defaultContext)
                    // then
                    expect(serviceOfferMock.sendRequestReceivedArguments?.pathContext).to(equal(TestData.defaultContext))
                    expect(result.error).toEventually(matchError(error))
                }
            }
        }
    }
}

private extension InstalmentListProviderTests {
    enum TestData {
        static let defaultContext = InstallmentOfferContext(installmentType: .credit, operationID: nil)
        static let model = InstalmentListResponse.Seeds.value
        static let offerModel = InstalmentOfferResponse.Seeds.value
    }
}
