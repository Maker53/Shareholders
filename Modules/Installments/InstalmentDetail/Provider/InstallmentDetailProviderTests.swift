//  Created by Assylkhan Turan on 27.07.2022.

import AlfaNetworking
import NetworkKit
import TestAdditions

@testable import Installments

final class InstallmentDetailProviderTests: QuickSpec {
    override func spec() {
        var serviceMock: NetworkServiceMock<[Instalment], Void, InstallmentType, ServiceError>!
        var dataStoreMock: StoresInstallmentDetailContextMock!
        var provider: InstallmentDetailProvider!

        beforeEach {
            serviceMock = .init()
            dataStoreMock = StoresInstallmentDetailContextMock()
            provider = InstallmentDetailProvider(
                dataStore: dataStoreMock,
                service: serviceMock
            )
        }

        describe(".getInstallment") {
            it("should call service") {
                // given
                let model = TestData.correctIDModel
                dataStoreMock.contextStub = TestData.defaultContext
                // when
                _ = provider.getInstallment(model: model)
                // then
                expect(serviceMock.sendRequestWasCalled).to(beCalledOnce())
                expect(serviceMock.sendRequestReceivedArguments?.pathContext).to(equal(model.installmentType))
            }

            context("when successful response") {
                context("when result have correct installment") {
                    context("when result have more than one installment") {
                        it("should call dataStore") {
                            // given
                            serviceMock.sendRequestCompletionStub = .success(TestData.installments)
                            dataStoreMock.contextStub = TestData.defaultContext
                            // when
                            _ = provider.getInstallment(model: TestData.correctIDModel)
                            // then
                            expect(dataStoreMock.setContextWasCalled).toEventually(beCalledOnce())
                            expect(dataStoreMock.context).toEventually(equal(TestData.defaultContext))
                            expect(dataStoreMock.context).toNotEventually(equal(TestData.isNotSeveralContext))
                        }
                    }
                    context("when result have only one installment") {
                        it("should call dataStore") {
                            // given
                            serviceMock.sendRequestCompletionStub = .success(TestData.oneInstallmentArray.instalments)
                            dataStoreMock.contextStub = TestData.isNotSeveralContext
                            // when
                            _ = provider.getInstallment(model: TestData.correctIDModel)
                            // then
                            expect(dataStoreMock.setContextWasCalled).toEventually(beCalledOnce())
                            expect(dataStoreMock.context).toEventually(equal(TestData.isNotSeveralContext))
                            expect(dataStoreMock.context).toNotEventually(equal(TestData.defaultContext))
                        }
                    }
                }

                context("when result does not have correct installment") {
                    context("when id does not match") {
                        it("should not call dataStore") {
                            // given
                            serviceMock.sendRequestCompletionStub = .success(TestData.installments)
                            // when
                            _ = provider.getInstallment(model: TestData.incorrectIDModel)
                            // then
                            expect(dataStoreMock.setContextWasCalled).toNotEventually(beCalled())
                        }
                    }
                    context("when agreementNumber does not match") {
                        it("should not call dataStore") {
                            // given
                            serviceMock.sendRequestCompletionStub = .success(TestData.installments)
                            // when
                            _ = provider.getInstallment(model: TestData.incorrectAgreementModel)
                            // then
                            expect(dataStoreMock.setContextWasCalled).toNotEventually(beCalled())
                        }
                    }
                }
            }

            context("when failure response") {
                it("should return error") {
                    // given
                    serviceMock.sendRequestCompletionStub = .failure(TestData.error)
                    // when
                    let result = provider.getInstallment(model: TestData.correctIDModel)
                    // then
                    expect(result.error).toEventually(matchError(TestData.error))
                }
            }
        }

        describe(".getInstallmentDetailContext") {
            it("should return context") {
                // given
                dataStoreMock.contextStub = TestData.defaultContext
                // then
                expect(provider.getInstallmentDetailContext()).to(equal(TestData.defaultContext))
            }
        }
    }
}

private extension InstallmentDetailProviderTests {
    enum TestData {
        static let defaultContext = InstallmentDetailsContext.full(InstallmentDetailsModel(
            installment: installment,
            installmentType: .credit,
            isSeveralInstallments: true
        ))
        static let isNotSeveralContext = InstallmentDetailsContext.full(InstallmentDetailsModel(
            installment: installment,
            installmentType: .credit,
            isSeveralInstallments: false
        ))
        static let installment = Instalment.Seeds.value
        static let installments = InstalmentListResponse.Seeds.value.instalments
        static let oneInstallmentArray = InstalmentListResponse(instalments: [installment])
        static let correctIDModel = InstallmentDetailsContext.PlainModel(
            uid: installment.uid,
            agreementNumber: installment.agreementNumber,
            installmentType: .credit
        )
        static let incorrectIDModel = InstallmentDetailsContext.PlainModel(
            uid: .empty,
            agreementNumber: .empty,
            installmentType: .credit
        )
        static let incorrectAgreementModel = InstallmentDetailsContext.PlainModel(
            uid: installment.uid,
            agreementNumber: .empty,
            installmentType: .credit
        )
        static let error = ServiceError.other
    }
}
