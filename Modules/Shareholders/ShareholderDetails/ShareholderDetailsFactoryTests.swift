// Created by Станислав on 16.02.2023.

import AlfaFoundation
import SharedProtocolsAndModels
import TestAdditions
@testable import Shareholders

final class ShareholderDetailsFactoryTests: QuickSpec {
    override func spec() {
        var featuresSeviceMock: FeaturesServiceMock!
        var factory: ShareholderDetailsFactory<ShareholderDetailsRoutesMock>!
        
        beforeEach {
            featuresSeviceMock = .init()
            factory = .init(featureService: featuresSeviceMock)
        }
        
        describe(".build") {
            it("should build module parts") {
                // when
                let viewController = try? factory.build(with: TestData.context)
                // then
                let interactor = viewController?.interactor as? ShareholderDetailsInteractor
                let presenter = interactor?.presenter as? ShareholderDetailsPresenter
                expect(viewController).toNot(beNil())
                expect(interactor).toNot(beNil())
                expect(presenter).toNot(beNil())
                expect(presenter?.featuresService).to(beIdenticalTo(featuresSeviceMock))
            }
            
            it("should set dependencies between module parts") {
                // when
                let viewController = try? factory.build(with: TestData.context)
                // then
                let interactor = viewController?.interactor as? ShareholderDetailsInteractor
                let presenter = interactor?.presenter as? ShareholderDetailsPresenter
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

private extension ShareholderDetailsFactoryTests {
    enum TestData {
        static var context: ShareholderDetailsFactory<ShareholderDetailsRoutesMock>.Context = .init(
            Shareholder.Seeds.value.id
        )
    }
}
