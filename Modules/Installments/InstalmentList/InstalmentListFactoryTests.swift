//  Created by Lyudmila Danilchenko on 17/08/2020.

import AlfaNetworking
import SharedProtocolsAndModels
import TestAdditions

@testable import Installments

final class InstalmentListFactoryTests: QuickSpec {
    override func spec() {
        var factory: InstalmentListFactory<InstalmentListRoutesMock>!
        var analyticsFacadeMock: AnalyticsFacadeMock!
        var featuresServiceMock: FeaturesServiceMock!

        beforeSuite {
            APIClientRegister.setup()
        }

        beforeEach {
            analyticsFacadeMock = AnalyticsFacadeMock()
            featuresServiceMock = .init()
            factory = InstalmentListFactory(
                analyticsFacade: analyticsFacadeMock,
                featuresService: featuresServiceMock
            )
        }

        describe(".build") {
            it("should build module parts") {
                // when
                let viewController = try? factory.build(with: TestData.context)
                // then
                let interactor = viewController?.interactor as? InstalmentListInteractor
                let presenter = interactor?.presenter
                expect(interactor).toNot(beNil())
                expect(interactor?.featuresService).to(beIdenticalTo(featuresServiceMock))
                expect(presenter).to(beAnInstanceOf(InstalmentListPresenter.self))
                expect(viewController).toNot(beNil())
            }

            it("should set dependencies between module parts") {
                // when
                let viewController = try? factory.build(with: TestData.context)
                // then
                let presenter = (viewController?.interactor as? InstalmentListInteractor)?.presenter as? InstalmentListPresenter
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
    }
}

private extension InstalmentListFactoryTests {
    enum TestData {
        static let context: InstalmentListFactory<InstalmentListRoutesMock>.Context = nil
    }
}
