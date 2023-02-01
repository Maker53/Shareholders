//  Created by Рамазанов Виталий Глебович on 27/08/2021.

import ABUIComponents
import ResultScreen
import SharedRouter

enum CancelInstallment {
    enum ErrorType: Equatable {
        case loadingFailed(String)
        case documentLoadingError(String)
    }

    enum InputError: Equatable {
        case empty
        case incorrect

        // MARK: Internal

        var errorMessage: String {
            switch self {
            case .empty:
                return L10n.Common.EmailError.emptyEmail
            case .incorrect:
                return L10n.Common.EmailError.invalidEmail
            }
        }
    }

    enum PresentModuleData {
        typealias Request = Parameters?

        struct Response: Equatable {
            let installment: Instalment
            let parameters: Parameters
        }

        struct ViewModel: Equatable {
            let titleViewModel: TextView.ViewModel
            let buttonTitle: String
            let sections: [CancelInstallmentSection]
            let parameters: Parameters
        }
    }

    enum PresentDocument {
        struct Request: Equatable {
            let parameters: Parameters
        }

        struct Response: Equatable {
            let url: URL
        }

        typealias ViewModel = Response
        typealias ErrorResponse = String
    }

    enum Cancel {
        struct Request: Equatable {
            let parameters: Parameters
        }

        struct Response: Equatable {
            let isSuccess: Bool
        }

        struct ViewModel: Equatable {
            let model: ResultScreenModel
        }
    }

    enum PresentEmptyState {
        typealias ViewModel = DefaultEmptyViewModel
    }

    enum UpdateInput {
        struct Request: Equatable {
            let parameters: Parameters
            let newEmail: String?
        }
    }

    struct Parameters: Equatable {
        let email: String?
        let inputError: InputError?
        let agreementNumber: String
        let installmentNumber: String
    }
}
