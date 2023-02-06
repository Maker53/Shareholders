// Created by Станислав on 06.02.2023.

import AlfaNetworking

final class ShareholderListNetworkService: EmptyRequestTrait, DecodableResponseTrait {
    typealias Model = [Shareholder]
    
    let apiClient: APIClient
    
    init(apiClient: APIClient = APIClientRegister.shared.client(withID: .unauthorizedSense)) {
        self.apiClient = apiClient
    }
    
    func endpoint(with context: Void) -> String {
        "v1/shareholders"
    }
}
