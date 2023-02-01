//  Created by Lyudmila Danilchenko on 25/10/2020.

import ABUIComponents
import AMSharedProtocolsAndModels
import TestAdditions

@testable import Installments

final class InstalmentDetailPresenterTests: QuickSpec {
    override func spec() {
        var presenter: InstalmentDetailPresenter!
        var viewControllerMock: InstalmentDetailDisplayLogicMock!
        var featureServiceMock: FeaturesServiceMock!
        var workerMock: InstallmentDetailPresenterWorkerMock!

        beforeEach {
            workerMock = .init()
            featureServiceMock = .init()
            presenter = InstalmentDetailPresenter(
                featureService: featureServiceMock,
                worker: workerMock
            )
            viewControllerMock = InstalmentDetailDisplayLogicMock()
            presenter.viewController = viewControllerMock
        }

        describe(".init") {
            it("should init properly") {
                expect(presenter.worker).to(beIdenticalTo(workerMock))
                expect(presenter.featureService).to(beIdenticalTo(featureServiceMock))
            }
        }

        describe(".presentDebitRepayment") {
            it("should ask view controller to display transfers") {
                // when
                presenter.presentDebitRepayment()
                // then
                expect(viewControllerMock.displayTransferWasCalled).to(beCalledOnce())
            }
        }

        describe(".presentData") {
            context("when installment type is credit") {
                context("when FT enabled") {
                    it("should not hide repayment") {
                        // given
                        workerMock.makeDataSectionsInstallmentInstallmentTypeStub = []
                        workerMock.makeEarlyRepaymentSectionsInstallmentInstallmentTypeIsFeatureAvailableStub = []
                        featureServiceMock.anySpecifiedEnabledFeatures = [
                            .extra(InstallmentsFeature.creditCardsPlanItEarlyRepayment.rawValue),
                        ]
                        // when
                        presenter.presentData(TestData.PresentData.response)
                        // then
                        expect(viewControllerMock.displayDataReceivedViewModel?.shouldHideRepayment).to(beFalse())
                    }
                }
                context("when FT disabled") {
                    it("should hide repayment") {
                        // given
                        workerMock.makeDataSectionsInstallmentInstallmentTypeStub = []
                        workerMock.makeEarlyRepaymentSectionsInstallmentInstallmentTypeIsFeatureAvailableStub = []
                        featureServiceMock.specifiedEnabledFeatures = []
                        // when
                        presenter.presentData(TestData.PresentData.response)
                        // then
                        expect(viewControllerMock.displayDataReceivedViewModel?.shouldHideRepayment).to(beTrue())
                    }
                }

                context("when cancellation is available and FT enabled") {
                    it("should hide repayment") {
                        // given
                        workerMock.makeDataSectionsInstallmentInstallmentTypeStub = []
                        workerMock.makeEarlyRepaymentSectionsInstallmentInstallmentTypeIsFeatureAvailableStub = []
                        featureServiceMock.anySpecifiedEnabledFeatures = [
                            .extra(InstallmentsFeature.creditCardsPlanItEarlyRepayment.rawValue),
                        ]
                        // when
                        presenter.presentData(TestData.PresentData.responseWithCancelanion)
                        // then
                        expect(viewControllerMock.displayDataReceivedViewModel?.shouldHideRepayment).to(beTrue())
                    }
                }
            }
            context("when installment type is debit") {
                context("when FT enabled") {
                    it("should not hide repayment") {
                        // given
                        workerMock.makeDataSectionsInstallmentInstallmentTypeStub = []
                        workerMock.makeEarlyRepaymentSectionsInstallmentInstallmentTypeIsFeatureAvailableStub = []
                        featureServiceMock.anySpecifiedEnabledFeatures = [.extra(AMSharedFeature.debitInstallment.rawValue)]
                        // when
                        presenter.presentData(TestData.PresentData.debitResponse)
                        // then
                        expect(viewControllerMock.displayDataReceivedViewModel?.shouldHideRepayment).to(beFalse())
                    }
                }
                context("when FT disabled") {
                    it("should hide repayment") {
                        // given
                        featureServiceMock.specifiedEnabledFeatures = []
                        // given
                        workerMock.makeDataSectionsInstallmentInstallmentTypeStub = []
                        workerMock.makeEarlyRepaymentSectionsInstallmentInstallmentTypeIsFeatureAvailableStub = []
                        // when
                        presenter.presentData(TestData.PresentData.debitResponse)
                        // then
                        expect(viewControllerMock.displayDataReceivedViewModel?.shouldHideRepayment).to(beTrue())
                    }
                }
            }
            context("when installment type is promotional") {
                context("when FT enabled") {
                    it("should not hide repayment") {
                        // given
                        workerMock.makeDataSectionsInstallmentInstallmentTypeStub = []
                        workerMock.makeEarlyRepaymentSectionsInstallmentInstallmentTypeIsFeatureAvailableStub = []
                        featureServiceMock.anySpecifiedEnabledFeatures = [.extra(AMSharedFeature.debitInstallment.rawValue)]
                        // when
                        presenter.presentData(TestData.PresentData.promotionalResponse)
                        // then
                        expect(viewControllerMock.displayDataReceivedViewModel?.shouldHideRepayment).to(beFalse())
                    }
                }
                context("when FT disabled") {
                    it("should hide repayment") {
                        // given
                        featureServiceMock.specifiedEnabledFeatures = []
                        workerMock.makeDataSectionsInstallmentInstallmentTypeStub = []
                        workerMock.makeEarlyRepaymentSectionsInstallmentInstallmentTypeIsFeatureAvailableStub = []
                        // when
                        presenter.presentData(TestData.PresentData.promotionalResponse)
                        // then
                        expect(viewControllerMock.displayDataReceivedViewModel?.shouldHideRepayment).to(beTrue())
                    }
                }
            }
            it("should present correct data") {
                // given
                workerMock.makeDataSectionsInstallmentInstallmentTypeStub = [TestData.PresentData.sectionsStub]
                workerMock.makeEarlyRepaymentSectionsInstallmentInstallmentTypeIsFeatureAvailableStub = [TestData.PresentData.sectionsStub]

                // when
                presenter.presentData(TestData.PresentData.response)
                // then
                expect(viewControllerMock.displayDataWasCalled).to(beCalledOnce())
                expect(viewControllerMock.displayDataReceivedViewModel).to(equal(TestData.PresentData.viewModel))
            }
        }

        describe(".presentTransfer") {
            it("should call controller") {
                // when
                presenter.presentTransfer()
                // then
                expect(viewControllerMock.displayTransferWasCalled).to(beCalledOnce())
            }
        }

        describe(".presentCancelInstallment") {
            it("should call controller") {
                // when
                presenter.presentCancelInstallment(TestData.cancelInstallmentResponse)
                // then
                expect(viewControllerMock.displayCancelInstalmentWasCalled).to(beCalledOnce())
                expect(viewControllerMock.displayCancelInstalmentReceivedViewModel).to(equal(TestData.cancelInstalmentViewModel))
            }
        }
    }
}

private extension InstalmentDetailPresenterTests {
    enum TestData {
        enum PresentData {
            static let featureStub = true
            static let sectionsStub: DetailInfoSection = .init(title: nil, cells: [])
            static let response = InstalmentDetail.PresentModuleData.Response(
                installment: installment,
                installmentType: .credit,
                isSeveralInstallments: false
            )
            static let debitResponse = InstalmentDetail.PresentModuleData.Response(
                installment: installment,
                installmentType: .debit,
                isSeveralInstallments: false
            )
            static let promotionalResponse = InstalmentDetail.PresentModuleData.Response(
                installment: installment,
                installmentType: .promotional,
                isSeveralInstallments: false
            )
            static let responseWithCancelanion = InstalmentDetail.PresentModuleData.Response(
                installment: Instalment.Seeds.valueCancellationAvailable,
                installmentType: .credit,
                isSeveralInstallments: false
            )
            static let viewModel = InstalmentDetail.PresentModuleData.ViewModel(
                sections: [sectionsStub, sectionsStub],
                shouldEnableRepayment: installment.earlyRepaymentAvailable,
                shouldHideRepayment: true,
                title: installment.title
            )
        }

        static let installment = Instalment.Seeds.value
        static let cancelInstallmentContext = CancelInstallmentContext(installment: installment)
        static let cancelInstallmentResponse = InstalmentDetail.PresentCancelInstalment.Response(
            cancelInstallmentContext: cancelInstallmentContext
        )
        static let cancelInstalmentViewModel = InstalmentDetail.PresentCancelInstalment.ViewModel(
            cancelInstallmentContext: cancelInstallmentContext
        )
    }
}
