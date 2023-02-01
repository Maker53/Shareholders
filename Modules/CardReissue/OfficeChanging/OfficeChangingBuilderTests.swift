//
//  SUT: OfficeChangingBuilder
//

import AlfaNetworking
import TestAdditions

@testable import CardReissue

final class OfficeChangingBuilderTests: QuickSpec {
    override func spec() {
        var builder: OfficeChangingBuilder!
        var routesMock: OfficeChangingRoutesMock.Type!

        beforeSuite {
            APIClientRegister.setup()
        }

        beforeEach {
            routesMock = OfficeChangingRoutesMock.self
            builder = OfficeChangingBuilder()
                .setRoutes(routesMock)
                .setCardID(TestData.cardID)
        }

        describe(".build") {
            it("should build module parts") {
                // when
                let controller = builder.build()
                let interactor = controller.interactor as? OfficeChangingInteractor
                let presenter = interactor?.presenter as? OfficeChangingPresenter

                // then
                expect(controller).toNot(beNil())
                expect(interactor).toNot(beNil())
                expect(presenter).toNot(beNil())
            }

            it("should set dependencies between module parts") {
                // when
                let controller = builder.build()
                let interactor = controller.interactor as? OfficeChangingInteractor
                let presenter = interactor?.presenter as? OfficeChangingPresenter

                // then
                expect(presenter?.viewController).to(beIdenticalTo(controller))
            }
        }
    }
}

private extension OfficeChangingBuilderTests {
    enum TestData {
        static let cardID = "123"
    }
}
