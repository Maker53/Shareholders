//  Created by Lyudmila Danilchenko on 17/08/2020.

import ABUIComponents
import SharedProtocolsAndModels

enum InstalmentList {
    /// Показ рассрочек
    enum PresentModuleData {
        struct Request: Equatable {
            var shouldRefreshInstalments: Bool
        }

        struct Response: Equatable {
            let paymentSum: Amount?
            let creditInstallments: [Instalment]
            let debitInstallments: [Instalment]
        }

        struct ViewModel: Equatable {
            let sections: [InstallmentListSection]
        }
    }

    /// Показ кнопки "+"
    enum PresentPlusButton {
        struct Reponse: Equatable {
            let shouldPresentButton: Bool
        }

        struct ViewModel: Equatable {
            let shouldPresentButton: Bool
        }
    }

    /// Показ новой рассрочки
    enum PresentNewInstalmentData {
        struct Response: Equatable {
            let creditOffers: InstalmentOfferResponse
            let debitOffers: InstalmentOfferResponse
        }

        struct ViewModel: Equatable {
            let offers: InstalmentOfferResponse
            let installmentType: InstallmentType
        }
    }

    /// Открытие экрана деталей рассрочки
    enum PresentInstallmentDetails {
        struct Request: Equatable {
            let installment: Instalment
            let installmentType: InstallmentType
        }

        typealias Response = InstallmentDetailsContext

        typealias ViewModel = InstallmentDetailsContext
    }

    /// Выбор типа новой рассрочки
    enum PresentNewInstalmentSelection {
        struct ViewModel: Equatable {
            let actions: [UIAlertAction]
        }
    }

    /// Показ ошибки
    enum LoadingError {
        struct Response: Equatable {
            let description: String
        }

        struct ViewModel: Equatable {
            let model: DefaultEmptyViewModel
            let description: String
        }
    }

    // Показ пустого состояния
    enum PresentEmptyState {
        struct OffersState: OptionSet {
            let rawValue: UInt8
            static let hasCreditOffer = OffersState(rawValue: 1 << 0)
            static let hasDebitOffer = OffersState(rawValue: 1 << 1)
        }

        struct Response: Equatable {
            let offersState: OffersState
        }

        struct ViewModel: Equatable {
            let emptyViewViewModel: DefaultEmptyViewModel
        }
    }
}
