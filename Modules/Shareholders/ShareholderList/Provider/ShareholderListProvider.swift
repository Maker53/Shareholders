// Created by Станислав on 08.02.2023.

import AlfaNetworking
import SharedPromiseKit

protocol ProvidesShareholderList: AnyObject {
    func fetchShareholderList(usingCache: Bool) -> Promise<ShareholderList>
}

final class ShareholderListProvider: ProvidesShareholderList {
    private let dataStore: StoresShareholderList
    private let service: ModelService<ShareholderList>
    
    init(dataStore: StoresShareholderList, service: ModelService<ShareholderList>) {
        self.dataStore = dataStore
        self.service = service
    }
    
    // MARK: - ProvidesShareholderList
    
    func fetchShareholderList(usingCache: Bool = true) -> Promise<ShareholderList> {
        if usingCache, let shareholders = dataStore.shareholderListModel {
            return .value(shareholders)
        }
        
        return service
            .sendRequest()
            .get { [weak self] in
                self?.dataStore.shareholderListModel = $0
            }
    }
}
