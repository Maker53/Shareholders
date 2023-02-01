//  Created by Рамазанов Виталий Глебович on 27/08/2021.

import AlfaNetworking
import OperationConfirmation
import SharedProtocolsAndModels
import TestAdditions

@testable import Installments

final class CancelInstallmentFactoryTests: QuickSpec {
    override func spec() {
        var factory: CancelInstallmentFactory<CancelInstallmentRoutesMock>!
        var analyticsFacadeMock: AnalyticsFacadeMock!

        beforeSuite {
            APIClientRegister.setup()
        }

        beforeEach {
            analyticsFacadeMock = AnalyticsFacadeMock()
            factory = CancelInstallmentFactory(analyticsFacade: analyticsFacadeMock)
        }

        describe(".build") {
            it("should build module parts") {
                // when
                let viewController = try? factory.build(with: TestData.context)
                // then
                let interactor = viewController?.interactor as? CancelInstallmentInteractor
                let provider: CancelInstallmentDocumentsProvider? = interactor?["documentsProvider"]
                let presenter: CancelInstallmentPresenter? = interactor?["presenter"]
                let dataStore: CancelInstallmentDataStore? = interactor?["dataStore"]
                expect(interactor).toNot(beNil())
                expect(presenter).toNot(beNil())
                expect(viewController).toNot(beNil())
                expect(provider).toNot(beNil())
                expect(dataStore).toNot(beNil())
                expect(dataStore?.installment).to(equal(TestData.context.installment))
                expect(interactor?.confirmationProvider).to(beAnInstanceOf(TestData.ConfirmationProviderType.self))
            }

            it("should set dependencies between module parts") {
                // when
                let viewController = try? factory.build(with: TestData.context)
                // then
                let interactor = viewController?.interactor as? CancelInstallmentInteractor
                let presenter: CancelInstallmentPresenter? = interactor?["presenter"]
                expect(presenter?.viewController).to(beIdenticalTo(viewController))
            }
        }

        describe(".deinit") {
            it("should not leak") {
                // when
                let result = MemoryLeakTest { try? factory.build(with: TestData.context) }
                // then
                expect(result).toNot(leak())
            }
        }

        describe(".isViewLoaded") {
            it("shouldn't call isViewLoaded") {
                // when
                let viewController = try? factory.build(with: TestData.context)
                // then
                expect(viewController?.isViewLoaded).to(beFalse())
            }
        }
    }
}

extension CancelInstallmentInteractor: PropertyReflectable { }

private extension CancelInstallmentFactoryTests {
    enum TestData {
        typealias ConfirmationProviderType = ParametrizedConfirmationProvider<CancelInstallmentConfirmationModel>

        static let context: CancelInstallmentFactory<CancelInstallmentRoutesMock>.Context = CancelInstallmentContext(
            installment: Instalment.Seeds.value
        )
    }
}
