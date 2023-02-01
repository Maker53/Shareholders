//  Created by Lyudmila Danilchenko on 25/10/2020.

import AlfaNetworking
import TestAdditions

@testable import Installments

final class InstalmentDetailInteractorTests: QuickSpec {
    override func spec() {
        var interactor: InstalmentDetailInteractor!
        var presenterMock: InstalmentDetailPresentationLogicMock!
        var providerMock: ProvidesInstallmentDetailMock!

        beforeEach {
            presenterMock = InstalmentDetailPresentationLogicMock()
            providerMock = ProvidesInstallmentDetailMock()
            interactor = InstalmentDetailInteractor(
                presenter: presenterMock,
                provider: providerMock
            )
        }

        describe(".init") {
            it("should configure interactor") {
                // then
                expect(interactor.presenter).to(beIdenticalTo(presenterMock))
            }
        }

        describe(".loadData") {
            context("when context is .full") {
                it("should call presenter") {
                    // given
                    providerMock.getInstallmentDetailContextStub = TestData.okStub
                    // when
                    interactor.loadData()
                    // then
                    expect(presenterMock.presentDataWasCalled).to(beCalledOnce())
                    expect(presenterMock.presentDataReceivedResponse).to(equal(TestData.response))
                }
            }
            context("when context is .plain") {
                beforeEach {
                    // given
                    providerMock.getInstallmentDetailContextStub = TestData.plainContextCredit
                }
                it("should call provider") {
                    // given
                    providerMock.getInstallmentModelStub = TestData.installmentsStub
                    // when
                    interactor.loadData()
                    // then
                    expect(providerMock.getInstallmentModelWasCalled).to(beCalledOnce())
                    expect(providerMock.getInstallmentModelReceivedModel)
                        .to(equal(TestData.plainCreditModel))
                }
                context("when result is success") {
                    context("when result have .full context") {
                        it("should call presentData") {
                            // given
                            providerMock.getInstallmentModelStub = TestData.installmentsStub
                            // when
                            interactor.loadData()
                            // then
                            providerMock.getInstallmentDetailContextStub = TestData.okStub
                            expect(presenterMock.presentDataWasCalled).toEventually(beCalledOnce())
                            expect(presenterMock.presentDataReceivedResponse).toEventually(equal(TestData.response))
                        }
                    }
                    context("when result have .plain context") {
                        it("should call presenteError") {
                            // given
                            providerMock.getInstallmentModelStub = TestData.installmentsStub
                            // when
                            interactor.loadData()
                            // then
                            expect(presenterMock.presentDataWasCalled).toNotEventually(beCalled())
                            expect(presenterMock.presentErrorWasCalled).toEventually(beCalledOnce())
                            expect(presenterMock.presentErrorReceivedErrorType).toEventually(equal(TestData.errorType))
                        }
                    }
                }
                context("when result is failure") {
                    it("should not call presenter") {
                        // given
                        providerMock.getInstallmentModelStub = TestData.errorStub
                        // when
                        interactor.loadData()
                        // then
                        expect(presenterMock.presentDataWasCalled).toNotEventually(beCalled())
                        expect(presenterMock.presentErrorWasCalled).toEventually(beCalledOnce())
                        expect(presenterMock.presentErrorReceivedErrorType).toEventually(equal(TestData.errorType))
                    }
                }
            }
        }
        
        describe(".openInfoDialog") {
            it("should call presenter") {
                // when
                interactor.openInfoDialog()
                // then
                expect(presenterMock.presentInfoDialogWasCalled).to(beCalledOnce())
            }
        }

        describe(".openTransfer") {
            it("should call presenter") {
                // when
                interactor.openTransfer()
                // then
                expect(presenterMock.presentTransferWasCalled).to(beCalledOnce())
            }
        }

        describe(".openCancelInstallment") {
            context("when context is .full") {
                it("should call presenter") {
                    // given
                    providerMock.getInstallmentDetailContextStub = TestData.debitStub
                    // when
                    interactor.openCancelInstallment()
                    // then
                    expect(providerMock.getInstallmentDetailContextWasCalled).to(beCalledOnce())
                    expect(presenterMock.presentCancelInstallmentWasCalled).to(beCalledOnce())
                    expect(presenterMock.presentCancelInstallmentReceivedResponse).to(equal(TestData.cancelInstallmentResponse))
                }
            }
            context("when context is .plain") {
                it("should not call presenter") {
                    // given
                    providerMock.getInstallmentDetailContextStub = TestData.plainContextCredit
                    // when
                    interactor.openCancelInstallment()
                    // then
                    expect(providerMock.getInstallmentDetailContextWasCalled).to(beCalledOnce())
                    expect(presenterMock.presentCancelInstallmentWasCalled).toNot(beCalled())
                }
            }
        }
    }
}

private extension InstalmentDetailInteractorTests {
    enum TestData {
        static let isSeveralInstallments = false
        static let creditInstallmentType: InstallmentType = .credit
        static let debitInstallmentType: InstallmentType = .debit
        static let promotionalInstallmentType: InstallmentType = .promotional
        static let debitStub = InstallmentDetailsContext.full(
            InstallmentDetailsModel(
                installment: installment,
                installmentType: debitInstallmentType,
                isSeveralInstallments: isSeveralInstallments
            )
        )
        static let promotionalStub = InstallmentDetailsContext.full(
            InstallmentDetailsModel(
                installment: installment,
                installmentType: promotionalInstallmentType,
                isSeveralInstallments: isSeveralInstallments
            )
        )
        static let okStub = InstallmentDetailsContext.full(
            InstallmentDetailsModel(
                installment: installment,
                installmentType: creditInstallmentType,
                isSeveralInstallments: isSeveralInstallments
            )
        )
        static let plainCreditModel = InstallmentDetailsContext.PlainModel(
            uid: installment.uid,
            agreementNumber: installment.agreementNumber,
            installmentType: creditInstallmentType
        )
        static let plainContextCredit = InstallmentDetailsContext.plain(plainCreditModel)
        static let plainContextDebit = InstallmentDetailsContext.plain(.init(
            uid: installment.uid,
            agreementNumber: installment.agreementNumber,
            installmentType: debitInstallmentType
        ))
        static let plainContextPromotional = InstallmentDetailsContext.plain(.init(
            uid: installment.uid,
            agreementNumber: installment.agreementNumber,
            installmentType: promotionalInstallmentType
        ))
        static let plainNotExistsIDContext = InstallmentDetailsContext.plain(.init(
            uid: .empty,
            agreementNumber: .empty,
            installmentType: creditInstallmentType
        ))
        static let instalmentNoCreditAccount = Instalment.Seeds.valueNoCreditAccount
        static let installment = Instalment.Seeds.value
        static let response = InstalmentDetail.PresentModuleData.Response(
            installment: installment,
            installmentType: creditInstallmentType,
            isSeveralInstallments: false
        )
        static let cancelInstallmentResponse = InstalmentDetail.PresentCancelInstalment.Response(
            cancelInstallmentContext: CancelInstallmentContext(installment: installment)
        )
        static let installmentsStub: Promise<[Instalment]> = .value([installment])
        static let errorStub: Promise<[Instalment]> = .init(error: ServiceError.other)
        static let errorType: InstalmentDetail.ErrorType = .loadingFailed(Resources.L10n.APIClientError.somethingWentWrong)
    }
}
