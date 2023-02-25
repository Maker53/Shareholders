// Created by Станислав on 16.02.2023.

import AlfaFoundation

enum ShareholderDetailsDataFlow {
    enum PresentShareholderDetails {
        struct Request: Equatable {
            let uid: UniqueIdentifier
        }
        
        struct Response: Equatable {
            let shareholderDetails: Shareholder
        }
        
        struct ViewModel: Equatable {
            let shareholderDetails: ShareholderCellViewModel
        }
    }
}
