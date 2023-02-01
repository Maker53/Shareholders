//  Created by Lyudmila Danilchenko on 21.10.2020.

import AlfaNetworking
import TestAdditions
@testable import Installments

final class InstalmentOfferServiceTests: QuickSpec {
    override func spec() {
        var service: InstalmentOfferService!

        beforeSuite {
            APIClientRegister.setup()
        }

        describe(".endpoint") {
            it("should generate right endpoint") {
                // when
                service = InstalmentOfferService()
                // then
                expect(service.endpoint(with: .init(installmentType: .credit, operationID: nil))).to(equal(TestData.expectedEndpoint))
                expect(service.endpoint(with: .init(installmentType: .credit, operationID: "123"))).to(equal(TestData.expectedEndpoint))
                expect(service.endpoint(with: .init(installmentType: .debit, operationID: nil))).to(equal(TestData.debitEndpoint))
                expect(service.endpoint(with: .init(installmentType: .debit, operationID: "123")))
                    .to(equal(TestData.debitEndpointWithOperationID))
                expect(service.endpoint(with: .init(installmentType: .promotional, operationID: nil)))
                    .to(equal(TestData.promotionalEndpoint))
                expect(service.endpoint(with: .init(installmentType: .promotional, operationID: "123")))
                    .to(equal(TestData.promotionalEndpointWithOperationID))
            }
        }
    }
}

extension InstalmentOfferServiceTests {
    enum TestData {
        static let expectedEndpoint = "v1/instalment-loan/offers"
        static let debitEndpoint = "v1/dc-installment-loan/offers"
        static let debitEndpointWithOperationID = "v1/dc-installment-loan/offers?operationId=123"
        static let promotionalEndpoint = "v1/dc-installment-loan/offers"
        static let promotionalEndpointWithOperationID = "v1/dc-installment-loan/offers?operationId=123"
    }
}
