// Created by Станислав on 08.02.2023.

import AlfaNetworking
import SharedPromiseKit

protocol ProvidesShareholderList: AnyObject {
    func fetchShareholderList() -> Promise<ShareholderList>
}

final class ShareholderListProvider: ProvidesShareholderList {
    private let service: ModelService<ShareholderList>
    
    init(service: ModelService<ShareholderList>) {
        self.service = service
    }
    
    // MARK: - ProvidesShareholderList
    
    func fetchShareholderList() -> Promise<ShareholderList> {
        service.sendRequest()
    }
}
