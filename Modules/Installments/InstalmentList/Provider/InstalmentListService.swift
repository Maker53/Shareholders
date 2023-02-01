//  Created by Lyudmila Danilchenko on 21.08.2020.

import AlfaNetworking
import NetworkKit

typealias InstalmentListServiceType = AnyNetworkService<
    [Instalment],
    Void,
    InstallmentType,
    ServiceError
>

final class InstalmentListService: EmptyRequestTrait, TranslatableResponseTrait {
    typealias Model = [Instalment]
    typealias PathContext = InstallmentType

    let apiClient: APIClient
    let modelTranslator: AnyTranslator<Model>
    let requestMethod: RequestMethod

    init(
        modelTranslator: AnyTranslator<[Instalment]> = AnyTranslator(NonRootEntitiesCollectionTranslator(
            entitiesTranslator: AnyTranslator(InstalmentTranslator()),
            arrayKey: "instalmentLoans"
        ))
    ) {
        apiClient = APIClientRegister.shared.client(withID: .sense)
        requestMethod = .get
        self.modelTranslator = modelTranslator
    }

    func endpoint(with context: InstallmentType) -> String {
        switch context {
        case .credit:
            return "v1/instalment-loan"
        case .debit, .promotional:
            return "v1/dc-installment-loan"
        }
    }
}
