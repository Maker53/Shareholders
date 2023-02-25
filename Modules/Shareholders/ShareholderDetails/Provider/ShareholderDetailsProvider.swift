// Created by Станислав on 22.02.2023.

import AlfaFoundation
import AlfaNetworking
import SharedPromiseKit

protocol ProvidesShareholderDetails: AnyObject {
    func fetchShareholderDetails(id: UniqueIdentifier) -> Promise<Shareholder>
}

final class ShareholderDetailsProvider: ProvidesShareholderDetails {
    private let dataStore: StoresShareholderList
    
    init(dataStore: StoresShareholderList) {
        self.dataStore = dataStore
    }
    
    // MARK: - ProvidesShareholderDetails
    
    func fetchShareholderDetails(id: UniqueIdentifier) -> Promise<Shareholder> {
        let values = dataStore.shareholderListModel?.values ?? []

        for value in values {
            if value.id == id {
                return .value(value)
            }
        }

        return .init(error: ServiceError.other)
    }
}
