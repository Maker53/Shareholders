// Created by Станислав on 09.02.2023.

import SharedProtocolsAndModels

protocol StoresShareholderList: AnyObject {
    var shareholderListModel: ShareholderList? { get set }
}

final class ShareholderListDataStore: StoresShareholderList {
    var shareholderListModel: ShareholderList?
}

// MARK: - Purgeable

extension ShareholderListDataStore: Purgeable {
    func purge() {
        shareholderListModel = nil
    }
}
