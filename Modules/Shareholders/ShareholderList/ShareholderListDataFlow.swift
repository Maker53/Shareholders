// Created by Станислав on 07.02.2023.

import AlfaFoundation

enum ShareholderListDataFlow {
    enum PresentShareholderList {
        struct Response: Equatable {
            let shareholders: ShareholderList
        }
        
        struct ViewModel: Equatable {
            let rows: [ShareholderListCellViewModel]
        }
    }
    
    enum PresentShareholderDetails {
        struct Request: Equatable {
            let uid: UniqueIdentifier
        }
        
        struct Response: Equatable {
            let uid: UniqueIdentifier
        }
        
        struct ViewModel: Equatable {
            let uid: UniqueIdentifier
        }
    }
}
