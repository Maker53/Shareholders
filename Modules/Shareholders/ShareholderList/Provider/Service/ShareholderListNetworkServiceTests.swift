// Created by Станислав on 07.02.2023.

import AlfaNetworking
import TestAdditions
@testable import Shareholders

final class ShareholderListNetworkServiceTests: QuickSpec {
    override func spec() {
        var networkService: ShareholderListNetworkService!
        
        beforeSuite {
            APIClientRegister.setup()
        }
        
        beforeEach {
            networkService = ShareholderListNetworkService()
        }
        
        describe(".init") {
            it("should init default value properly") {
                // then
                expect(networkService.apiClient).to(beIdenticalTo(TestData.apiClient))
            }
        }
        
        describe(".endpoint") {
            it("should generate correct endpoint") {
                // then
                expect(networkService.endpoint(with: ())).to(equal(TestData.staticEndpoint))
            }
        }
    }
}

// MARK: - TestData

private extension ShareholderListNetworkServiceTests {
    enum TestData {
        static let staticEndpoint = "v1/shareholders"
        static let apiClient = APIClientRegister.shared.client(withID: .unauthorizedSense)
    }
}
