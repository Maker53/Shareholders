import TestAdditions

@testable import Installments

final class CancellationDraftServiceTests: QuickSpec {
    override func spec() {
        var service: CancellationDraftService!

        beforeEach {
            service = .init()
        }

        describe(".endpoint") {
            it("should be correct") {
                // then
                expect(service.endpoint(with: ())).to(equal(TestData.expectedEndpoint))
            }
        }

        describe(".encoderParameters") {
            it("should return correct parameters") {
                // when
                let requestParameters = service.encoderParameters(from: TestData.parameters)
                // then
                expect(requestParameters).to(equal(TestData.expectedParameters))
            }
        }
    }
}

private extension CancellationDraftServiceTests {
    enum TestData {
        static let expectedEndpoint = "v1/instalment-loan/documents/cancellation/draft"
        static let parameters = CancellationDraftParameters(
            agreementNumber: "123",
            installmentNumber: "123"
        )
        static let expectedParameters: [String: Any] = [
            "agreementNumber": parameters.agreementNumber,
            "installmentNumber": parameters.installmentNumber,
        ]
    }
}
