import AlfaNetworking
import TestAdditions

@testable import Installments

final class CancelInstallmentDocumentsProviderTests: QuickSpec {
    override func spec() {
        var provider: CancelInstallmentDocumentsProvider!
        var serviceMock: NetworkServiceMock<Data, CancellationDraftParameters, Void, ServiceError>!

        beforeEach {
            serviceMock = .init()
            provider = .init(
                cancellationDraftService: .init(serviceMock)
            )
        }

        describe(".getCancellationDraft") {
            it("should ask service to request document") {
                // when
                _ = provider.getCancellationDraft(parameters: TestData.parameters)
                // then
                expect(serviceMock.sendRequestWasCalled).to(beCalledOnce())
                expect(serviceMock.sendRequestReceivedArguments?.parameters)
                    .to(equal(TestData.parameters))
            }
        }
    }
}

extension CancelInstallmentDocumentsProvider: PropertyReflectable { }

private extension CancelInstallmentDocumentsProviderTests {
    enum TestData {
        static let parameters = CancellationDraftParameters(agreementNumber: "123", installmentNumber: "123")
    }
}
