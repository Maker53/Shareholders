//  Created by Roman Turov on 25/04/2019.

import AlfaNetworking
import NetworkKit

protocol UpdatesReissuesOffice {
    func updateReissuesOffice(
        cardID: String,
        officeID: String,
        completion: @escaping (RResult<Any, ServiceError>) -> Void
    )
}

extension UpdatesReissuesOffice {
    func updateReissuesOffice(cardID: String, officeID: String) -> Promise<Any> {
        Promise { updateReissuesOffice(cardID: cardID, officeID: officeID, completion: $0.resolve) }
    }
}

class OfficeChangingUpdateService: UpdatesReissuesOffice {
    let apiClient: APIClient

    init(apiClient: APIClient = APIClientRegister.shared.client(withID: .sense)) {
        self.apiClient = apiClient
    }

    func updateReissuesOffice(
        cardID: String,
        officeID: String,
        completion: @escaping (RResult<Any, ServiceError>) -> Void
    ) {
        let endpoint = "v1/cards/\(cardID)/issuing-office"
        let params = ["officeId": officeID]
        apiClient.put(endpoint: endpoint, withParameters: params) { (result: ParsedResult<Any>) in
            switch result {
            case let .success(value):
                completion(.success(value))
            case let .failure(error):
                completion(.failure(ServiceError.error(from: error)))
            }
        }
    }
}
