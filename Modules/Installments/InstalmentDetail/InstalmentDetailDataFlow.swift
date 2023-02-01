//  Created by Lyudmila Danilchenko on 25/10/2020.

import SharedProtocolsAndModels
import SharedRouter

enum InstalmentDetail {
    enum ErrorType: Equatable {
        case loadingFailed(String)
    }

    enum PresentModuleData {
        struct Request: Equatable { }

        typealias Response = InstallmentDetailsModel

        struct ViewModel: Equatable {
            let sections: [DetailInfoSection]
            let shouldEnableRepayment: Bool
            let shouldHideRepayment: Bool
            let title: String
        }
    }

    enum PresentDebitDialog {
        struct Response: Equatable {
            let isSeveralInstallments: Bool
        }
    }

    enum PresentCancelInstalment {
        struct Response: Equatable {
            let cancelInstallmentContext: CancelInstallmentContext
        }

        struct ViewModel: Equatable {
            let cancelInstallmentContext: CancelInstallmentContext
        }
    }

    static let cancelNotificationName = NSNotification.Name("CancelInstallmentButtonAction")
}
