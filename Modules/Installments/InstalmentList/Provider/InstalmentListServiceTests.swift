//  Created by Lyudmila Danilchenko on 21.08.2020.

import AlfaNetworking
import TestAdditions
@testable import Installments

final class InstalmentListServiceTests: QuickSpec {
    override func spec() {
        var service: InstalmentListService!

        beforeSuite {
            APIClientRegister.setup()
        }

        describe(".endpoint") {
            it("should generate right endpoint") {
                // when
                service = InstalmentListService()
                // then
                expect(service.endpoint(with: .credit)).to(equal(TestData.expectedEndpoint))
                expect(service.endpoint(with: .debit)).to(equal(TestData.debitEndpoint))
                expect(service.endpoint(with: .promotional)).to(equal(TestData.promotionalEndpoint))
            }
        }
    }
}

extension InstalmentListServiceTests {
    enum TestData {
        static let expectedEndpoint = "v1/instalment-loan"
        static let debitEndpoint = "v1/dc-installment-loan"
        static let promotionalEndpoint = "v1/dc-installment-loan"
    }
}
