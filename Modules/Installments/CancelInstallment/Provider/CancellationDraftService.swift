import AlfaNetworking

typealias CancellationDraftServiceProtocol = AnyNetworkService<Data, CancellationDraftParameters, Void, ServiceError>

struct CancellationDraftParameters: Encodable, Equatable {
    let agreementNumber: String
    let installmentNumber: String
}

final class CancellationDraftService: DictionaryRequestTrait, DecodableResponseTrait {
    typealias Parameters = CancellationDraftParameters
    typealias Model = Data

    func endpoint(with _: Void) -> String {
        "v1/instalment-loan/documents/cancellation/draft"
    }

    func encoderParameters(from parameters: CancellationDraftParameters) -> [String: Any] {
        [
            "agreementNumber": parameters.agreementNumber,
            "installmentNumber": parameters.installmentNumber,
        ]
    }
}
