//  Created by Рамазанов Виталий Глебович on 27/08/2021.

import AlfaNetworking
import OperationConfirmation
import TestAdditions

@testable import Installments

final class CancelInstallmentInteractorTests: QuickSpec {
    override func spec() {
        var interactor: CancelInstallmentInteractor!
        var presenterMock: CancelInstallmentPresentationLogicMock!
        var documentsProviderMock: ProvidesCancelInstallmentDocumentsMock!
        var dataStoreMock: StoresCancelInstallmentMock!
        var confirmationProviderMock: ProvidesOperationConfirmationMock<
            CancelInstallmentConfirmationModel,
            CancelInstallmentConfirmationModel,
            OperationConfirmationModel,
            ValidatePasswordResponse
        >!
        var providerInitMock: ParametrizedConfirmationProvider<CancelInstallmentConfirmationModel>!

        beforeEach {
            presenterMock = CancelInstallmentPresentationLogicMock()
            documentsProviderMock = .init()
            confirmationProviderMock = .init()
            providerInitMock = .init(confirmationProviderMock)
            dataStoreMock = .init()
            interactor = CancelInstallmentInteractor(
                presenter: presenterMock,
                documentsProvider: documentsProviderMock,
                confirmationProvider: providerInitMock,
                dataStore: dataStoreMock
            )
        }

        describe(".init") {
            it("should configure interactor") {
                // then
                expect(interactor["presenter"]).to(beIdenticalTo(presenterMock))
                expect(interactor["documentsProvider"]).to(beIdenticalTo(documentsProviderMock))
                expect(interactor["dataStore"]).to(beIdenticalTo(dataStoreMock))
            }
        }

        describe(".loadData") {
            context("when email is valid") {
                it("should pass correct response to presenter") {
                    // given
                    dataStoreMock.installmentStub = TestData.installment
                    // when
                    interactor.loadData(TestData.LoadData.ValidEmail.request)
                    // then
                    expect(presenterMock.presentDataWasCalled).to(beCalledOnce())
                    expect(presenterMock.presentDataReceivedResponse).to(equal(TestData.LoadData.ValidEmail.expectedResponse))
                    expect(dataStoreMock.getInstallmentWasCalled).to(beCalledOnce())
                }
            }

            context("when email is invalid") {
                it("should pass correct response to presenter") {
                    // given
                    dataStoreMock.installmentStub = TestData.installment
                    // when
                    interactor.loadData(TestData.LoadData.InvalidEmail.request)
                    // then
                    expect(presenterMock.presentDataWasCalled).to(beCalledOnce())
                    expect(presenterMock.presentDataReceivedResponse).to(equal(TestData.LoadData.InvalidEmail.expectedResponse))
                    expect(dataStoreMock.getInstallmentWasCalled).to(beCalledOnce())
                }
            }

            context("when email is empty") {
                it("should pass correct response to presenter") {
                    // given
                    dataStoreMock.installmentStub = TestData.installment
                    // when
                    interactor.loadData(TestData.LoadData.EmptyEmail.request)
                    // then
                    expect(presenterMock.presentDataWasCalled).to(beCalledOnce())
                    expect(presenterMock.presentDataReceivedResponse).to(equal(TestData.LoadData.EmptyEmail.expectedResponse))
                    expect(dataStoreMock.getInstallmentWasCalled).to(beCalledOnce())
                }
            }
        }

        describe(".loadDocument") {
            context("when fetch successfully") {
                it("should ask presenter to present document") {
                    // given
                    documentsProviderMock.getCancellationDraftParametersStub = TestData.LoadDocument.successStub
                    // when
                    interactor.loadDocument(TestData.LoadDocument.request)
                    // then
                    expect(presenterMock.presentDocumentWasCalled).toEventually(beCalledOnce())
                    expect(presenterMock.presentDocumentReceivedResponse)
                        .toEventually(equal(TestData.LoadDocument.expectedResponse))
                    expect(documentsProviderMock.getCancellationDraftParametersWasCalled).toEventually(beCalledOnce())
                    expect(documentsProviderMock.getCancellationDraftParametersReceivedParameters)
                        .toEventually(equal(TestData.LoadDocument.documentParameters))
                }
            }
            context("when fetch fails") {
                it("should ask presenter to present error") {
                    // given
                    documentsProviderMock.getCancellationDraftParametersStub = TestData.LoadDocument.failureStub
                    // when
                    interactor.loadDocument(TestData.LoadDocument.request)
                    // then
                    expect(presenterMock.presentErrorWasCalled).toEventually(beCalledOnce())
                    expect(presenterMock.presentErrorReceivedErrorType)
                        .toEventually(equal(TestData.LoadDocument.expectedError))
                }
            }
        }
        describe(".cancelInstallment") {
            context("when request has email") {
                it("should call confirmation provider with correct model") {
                    // given
                    confirmationProviderMock.confirmationReferenceParametersStub =
                        .value(TestData.Cancel.referenceStub)
                    // when
                    interactor.cancelInstallment(TestData.Cancel.request)
                    // then
                    expect(confirmationProviderMock.confirmationReferenceParametersWasCalled).to(beCalledOnce())
                    expect(confirmationProviderMock.confirmationReferenceParametersReceivedParameters)
                        .to(equal(TestData.Cancel.model))
                }
            }
            context("when request has not email") {
                it("should do nothing") {
                    // given
                    confirmationProviderMock.confirmationReferenceParametersStub =
                        .value(TestData.Cancel.referenceStub)
                    // when
                    interactor.cancelInstallment(TestData.Cancel.requestEmptyEmail)
                    // then
                    expect(confirmationProviderMock.confirmationReferenceParametersWasCalled).toNot(beCalled())
                }
            }
        }

        describe(".didCompleteConfirmation") {
            context("when confirmationValidatePassword is nil") {
                it("should ask presenter to present empty state") {
                    // given
                    interactor.confirmationValidatePassword = nil
                    // when
                    interactor.didCompleteConfirmation()
                    // then
                    expect(presenterMock.presentEmptyStateWasCalled).to(beCalledOnce())
                }
            }
            context("when confirmationValidatePassword is not nil") {
                it("should ask presenter to present result screen") {
                    // given
                    interactor.confirmationValidatePassword = .init()
                    // when
                    interactor.didCompleteConfirmation()
                    // then
                    expect(presenterMock.presentResultScreenWasCalled).to(beCalledOnce())
                    expect(presenterMock.presentResultScreenReceivedResponse)
                        .to(equal(.init(isSuccess: true)))
                }
            }
        }
    }
}

// swiftlint:disable nesting

private extension CancelInstallmentInteractorTests {
    enum TestData {
        enum LoadData {
            enum InvalidEmail {
                static let request = CancelInstallment.Parameters(
                    email: "incorrect",
                    inputError: nil,
                    agreementNumber: installment.agreementNumber,
                    installmentNumber: installment.uid
                )
                static let expectedResponse = CancelInstallment.PresentModuleData.Response(
                    installment: installment,
                    parameters: .init(
                        email: request.email,
                        inputError: .incorrect,
                        agreementNumber: installment.agreementNumber,
                        installmentNumber: installment.uid
                    )
                )
            }

            enum ValidEmail {
                static let request = CancelInstallment.Parameters(
                    email: "test@alfabank.ru",
                    inputError: nil,
                    agreementNumber: installment.uid,
                    installmentNumber: installment.uid
                )
                static let expectedResponse = CancelInstallment.PresentModuleData.Response(
                    installment: installment,
                    parameters: .init(
                        email: request.email,
                        inputError: nil,
                        agreementNumber: installment.agreementNumber,
                        installmentNumber: installment.uid
                    )
                )
            }

            enum EmptyEmail {
                static let request = CancelInstallment.PresentModuleData.Request.none
                static let expectedResponse = CancelInstallment.PresentModuleData.Response(
                    installment: installment,
                    parameters: .init(
                        email: nil,
                        inputError: .empty,
                        agreementNumber: installment.agreementNumber,
                        installmentNumber: installment.uid
                    )
                )
            }
        }

        enum LoadDocument {
            static let parameters = CancelInstallment.Parameters(
                email: .empty,
                inputError: .empty,
                agreementNumber: "123",
                installmentNumber: "123"
            )
            static let request = CancelInstallment.PresentDocument.Request(parameters: parameters)
            static let url = URL(fileURLWithPath: NSTemporaryDirectory() + "\(L10n.CancelInstallment.cancelDocumentTitle).pdf")
            static let expectedResponse = CancelInstallment.PresentDocument.Response(url: url)
            static let expectedError = CancelInstallment.ErrorType.documentLoadingError(ServiceError.other.localizedDescription)
            static let successStub = Promise<Data>.value(.init())
            static let failureStub = Promise<Data>(error: ServiceError.other)
            static let documentParameters = CancellationDraftParameters(
                agreementNumber: "123",
                installmentNumber: "123"
            )
        }

        enum Cancel {
            static let parameters = CancelInstallment.Parameters(
                email: "mis1@alfabank.ru",
                inputError: .empty,
                agreementNumber: "123",
                installmentNumber: "123"
            )
            static let parametersEmptyEmail = CancelInstallment.Parameters(
                email: .empty,
                inputError: .incorrect,
                agreementNumber: "123",
                installmentNumber: "123"
            )
            static let requestEmptyEmail = CancelInstallment.Cancel.Request(parameters: parametersEmptyEmail)
            static let request = CancelInstallment.Cancel.Request(parameters: parameters)
            static let referenceStub = OperationConfirmationModel(
                reference: "",
                auth: "",
                passwordLength: 4
            )
            static let model = CancelInstallmentConfirmationModel(email: "mis1@alfabank.ru")
        }

        static let installment = Instalment.Seeds.valueCancellationAvailable
        static let dataStore = CancelInstallmentDataStore(installment: installment)
    }
}
