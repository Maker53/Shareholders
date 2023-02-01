//  Created by Lyudmila Danilchenko on 25/10/2020.

import AlfaNetworking
import SharedProtocolsAndModels
import TestAdditions

@testable import Installments

final class InstalmentDetailFactoryTests: QuickSpec {
    override func spec() {
        var factory: InstalmentDetailFactory<InstalmentDetailRoutesMock>!
        var analyticsFacadeMock: AnalyticsFacadeMock!
        var featuresServiceMock: FeaturesServiceMock!

        beforeSuite {
            APIClientRegister.setup()
        }

        beforeEach {
            analyticsFacadeMock = AnalyticsFacadeMock()
            featuresServiceMock = .init()
            factory = InstalmentDetailFactory(
                analyticsFacade: analyticsFacadeMock,
                featureService: featuresServiceMock
            )
        }

        describe(".build") {
            it("should build module parts") {
                // when
                let viewController = try? factory.build(with: TestData.context)
                // then
                let interactor = viewController?.interactor as? InstalmentDetailInteractor
                let presenter = interactor?.presenter
                expect(interactor).toNot(beNil())
                expect(presenter).to(beAnInstanceOf(InstalmentDetailPresenter.self))
                expect(viewController).toNot(beNil())
                expect((viewController?.analytics as? InstalmentDetailAnalytics)?.analyticsFacade)
                    .to(beIdenticalTo(analyticsFacadeMock))
            }

            it("should set dependencies between module parts") {
                // when
                let viewController = try? factory.build(with: TestData.context)
                // then
                let interactor = viewController?.interactor as? InstalmentDetailInteractor
                let presenter = (viewController?.interactor as? InstalmentDetailInteractor)?.presenter as? InstalmentDetailPresenter
                let featureService = presenter?.featureService
                expect(featureService).to(beIdenticalTo(featuresServiceMock))
                expect(presenter?.viewController).to(beIdenticalTo(viewController))
                expect(interactor?.provider).to(beAnInstanceOf(InstallmentDetailProvider.self))
            }

            context("when context is .plain") {
                it("should be correct installment type") {
                    // when
                    let viewController = try? factory.build(with: TestData.plainContext)
                    // then
                    expect((viewController?.analytics as? InstalmentDetailAnalytics)?.installmentType)
                        .to(equal(TestData.installmentType))
                }
            }
            context("when context is .full") {
                it("should be correct installment type") {
                    // when
                    let viewController = try? factory.build(with: TestData.context)
                    // then
                    expect((viewController?.analytics as? InstalmentDetailAnalytics)?.installmentType)
                        .to(equal(TestData.installmentType))
                }
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
    }
}

private extension InstalmentDetailFactoryTests {
    enum TestData {
        static let installmentType: InstallmentType = .credit
        static let context: InstalmentDetailFactory<InstalmentDetailRoutesMock>.Context = .full(
            InstallmentDetailsModel(
                installment: Instalment.Seeds.value,
                installmentType: installmentType,
                isSeveralInstallments: true
            )
        )
        static let plainContext: InstalmentDetailFactory<InstalmentDetailRoutesMock>.Context = .plain(.init(
            uid: .empty,
            agreementNumber: .empty,
            installmentType: installmentType
        ))
    }
}
