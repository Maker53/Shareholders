//  Created by Vitaliy Ramazanov on 17.02.2021.

import ABUIComponents

struct InstalmentDetailPopUpViewModel: Equatable, DataViewViewModelRepresentable, OldRightIconWrapperViewModel {
    let title: String
    let rightIcon: IconViewViewModel

    var contentViewModel: DataViewViewModelRepresentable { self }

    var dataContent: OldDataContentViewModel {
        .init(title: title)
    }

    let icon: IconViewViewModel = .init()

    let useInWrapper: Bool = true
}
