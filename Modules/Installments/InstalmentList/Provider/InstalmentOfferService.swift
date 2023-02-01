//  Created by Lyudmila Danilchenko on 21.10.2020.

import AlfaNetworking
import NetworkKit

typealias InstalmentOfferServiceType = AnyNetworkService<
    InstalmentOfferResponse,
    Void,
    InstallmentOfferContext,
    ServiceError
>

struct InstallmentOfferContext: Equatable {
    let installmentType: InstallmentType
    let operationID: String?
}

final class InstalmentOfferService: EmptyRequestTrait, DecodableResponseTrait {
    typealias Model = InstalmentOfferResponse
    typealias PathContext = InstallmentOfferContext

    func endpoint(with context: InstallmentOfferContext) -> String {
        switch context.installmentType {
        case .credit:
            return "v1/instalment-loan/offers"
        case .debit, .promotional:
            guard let operationID = context.operationID else {
                return "v1/dc-installment-loan/offers"
            }
            return "v1/dc-installment-loan/offers?operationId=\(operationID)"
        }
    }
}
