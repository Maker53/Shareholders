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
        
        describe(".endpoint") {
            it("should generate correct endpoint") {
                // when
                networkService = ShareholderListNetworkService()
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
    }
}
