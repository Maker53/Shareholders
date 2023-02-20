// Created by Станислав on 14.02.2023.

import ABUIComponents
import SharedProtocolsAndModels

struct ShareholderListCellViewModel: Equatable, ContactCellViewModel {
    let name: String
    let phone: String?
    let imageSource: ImageSource
}
