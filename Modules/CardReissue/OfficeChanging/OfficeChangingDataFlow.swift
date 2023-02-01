///  Created by Roman Turov on 16/04/2019.

import ABUIComponents
import AMSharedProtocolsAndModels

enum OfficeChanging {
    enum PresentCells {
        struct Response {
            let items: [PresentedCellType]
            let isConfirmationAvailable: Bool
        }

        struct ViewModel {
            let pickerViewModels: [OfficeChangingViewModel]
            let isConfirmationButtonActive: Bool
        }
    }

    enum OpenItemsList {
        struct ViewModel {
            let cells: [OfficeChangingCellViewModel]
            let presentedCellType: OfficeChangingRowType
            let selectedItemIndex: Int?
        }
    }

    enum OpenCitiesList {
        struct Response {
            let itemsList: [City]
            let selectedItemIndex: Int?
        }
    }

    enum SelectCity {
        struct Request {
            let index: Int
        }
    }

    enum OpenMetroList {
        struct Response {
            let itemsList: [Metro]
            let selectedItemIndex: Int?
        }
    }

    enum SelectMetro {
        struct Request {
            let index: Int
        }
    }

    enum OpenOfficesList {
        struct Response {
            let itemsList: [Office]
            let selectedItemIndex: Int?
        }
    }

    enum SelectOffice {
        struct Request {
            let index: Int
        }
    }

    enum PresentedCellType: Equatable {
        case city(City?)
        case metro(Metro?)
        case office(Office?)
    }

    enum ErrorType: LocalizedError, Equatable {
        case emptyState
        case defaultError
        case error(message: String)

        // MARK: Internal

        var errorDescription: String? {
            switch self {
            case .emptyState:
                return nil
            case .defaultError:
                return "CardReissue.SomethingWentWrong".localized() as String
            case let .error(message):
                return message
            }
        }
    }
}
