//  Created by Lyumila Danilchenko on 21.08.2020.

import SharedProtocolsAndModels

protocol StoresInstalmentList: AnyObject {
    var instalmentListModelWithType: [InstallmentType: InstalmentListResponse?] { get set }
    var instalmentOffersModelWithType: [InstallmentType: InstalmentOfferResponse?] { get set }
}

final class InstalmentListDataStore: StoresInstalmentList {
    var instalmentListModelWithType: [InstallmentType: InstalmentListResponse?] = [:]
    var instalmentOffersModelWithType: [InstallmentType: InstalmentOfferResponse?] = [:]
}

// MARK: - Purgeable

extension InstalmentListDataStore: Purgeable {
    func purge() {
        instalmentListModelWithType = [
            .credit: nil,
            .debit: nil,
        ]
        instalmentOffersModelWithType = [
            .credit: nil,
            .debit: nil,
        ]
    }
}
