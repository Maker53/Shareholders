//  Created by Lyudmila Danilchenko on 22.09.2021.

import AlfaNetworking
import NetworkKit
import OperationConfirmation
import SharedProtocolsAndModels

struct CancelInstallmentConfirmationModel: Encodable, Equatable {
    let email: String
}

typealias CancelInstallmentConfirmationProvider = ParametrizedOperationConfirmationProvider<CancelInstallmentConfirmationModel>

extension CancelInstallmentConfirmationProvider {
    private enum Endpoints {
        static let endpoint = "v1/instalment-loan/installments/"
        static let validate = "v1/pipe"
    }

    convenience init(agreementNumber: String, installmentNumber: String) {
        self.init(
            referenceService: .init(
                CodableSimpleService(
                    endpoint: "\(Endpoints.endpoint)\(agreementNumber)/\(installmentNumber)/applications/cancel",
                    apiClient: APIClientRegister.shared.client(withID: .sense),
                    requestMethod: .post
                )
            ),
            validatePasswordService: .init(
                ConfirmationValidateService(
                    endpoint: Endpoints.validate
                )
            )
        )
    }
}
