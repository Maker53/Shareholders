//  Created by milaL Danichenko on 14.09.2021.

import SharedProtocolsAndModels

protocol StoresCancelInstallment: AnyObject {
    var installment: Instalment { get set }
}

final class CancelInstallmentDataStore: StoresCancelInstallment {
    var installment: Instalment

    init(installment: Instalment) {
        self.installment = installment
    }
}
