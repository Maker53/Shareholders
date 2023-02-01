//  Created by Виталий Рамазанов on 01.03.2021.

import ABUIComponents

struct DataViewModel: Equatable, DataViewViewModelRepresentable {
    let dataContent: OldDataContentViewModel
    let icon: IconViewViewModel
    let useInWrapper: Bool

    init(dataContent: OldDataContentViewModel, icon: IconViewViewModel, useInWrapper: Bool = false) {
        self.dataContent = dataContent
        self.icon = icon
        self.useInWrapper = useInWrapper
    }
}
