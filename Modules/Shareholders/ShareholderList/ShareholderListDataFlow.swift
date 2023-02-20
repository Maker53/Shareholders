// Created by Станислав on 07.02.2023.

enum ShareholderListDataFlow {
    enum PresentShareholderList {
        struct Response: Equatable {
            let shareholders: ShareholderList
        }
        
        struct ViewModel: Equatable {
            let rows: [ShareholderListCellViewModel]
        }
    }
}
