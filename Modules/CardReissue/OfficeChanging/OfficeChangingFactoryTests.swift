//
//  SUT: OfficeChangingFactory
//

import SharedRouter
import TestAdditions

@testable import CardReissue

final class OfficeChangingFactoryTests: QuickSpec {
    override func spec() {
        var factory: OfficeChangingFactory!
        var builderMock: OfficeChangingBuilderMock!
        var routesMock: OfficeChangingRoutesMock.Type!

        beforeEach {
            routesMock = OfficeChangingRoutesMock.self
            builderMock = OfficeChangingBuilderMock()
            factory = OfficeChangingFactory(builder: builderMock, routes: routesMock)
        }

        describe(".build") {
            it("should build module parts") {
                // when
                let controller = try? factory.build(with: TestData.context)
                // then
                expect(controller).toNot(beNil())
                expect(builderMock.setCardIDWasCalled).to(beCalledOnce())
                expect(builderMock.cardID).to(equal(TestData.cardID))
                expect(builderMock.setRoutesWasCalled).to(beCalledOnce())
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

private extension OfficeChangingFactoryTests {
    enum TestData {
        static let cardID = UUID().uuidString
        static let context = OfficeChangingFactory.Context(cardID: cardID, delegateBlock: nil)
    }
}
