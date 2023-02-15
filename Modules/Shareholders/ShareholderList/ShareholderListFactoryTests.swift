// Created by Станислав on 07.02.2023.

import TestAdditions
@testable import Shareholders

final class ShareholderListFactoryTests: QuickSpec {
    override func spec() {
        var factory: ShareholderListFactory<ShareholderListRoutesMock>!
        
        beforeEach {
            factory = .init()
        }
        
        describe(".build") {
            it("should build module parts") {
                // when
                let viewController = try? factory.build(with: TestData.context)
                // then
                let interactor = viewController?.interactor as? ShareholderListInteractor
                let presenter = interactor?.presenter as? ShareholderListPresenter
                expect(interactor).toNot(beNil())
                expect(presenter).toNot(beNil())
            }
            
            it("should set dependencies between module parts") {
                // when
                let viewController = try? factory.build(with: TestData.context)
                // then
                let presenter = (viewController?.interactor as? ShareholderListInteractor)?.presenter as? ShareholderListPresenter
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

// MARK: - TestData

private extension ShareholderListFactoryTests {
    enum TestData {
        static let context: ShareholderListFactory<ShareholderListRoutesMock>.Context = nil
    }
}
