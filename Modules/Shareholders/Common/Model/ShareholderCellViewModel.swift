// Created by Станислав on 14.02.2023.

import AlfaFoundation
import ABUIComponents
import SharedProtocolsAndModels

struct ShareholderCellViewModel: Equatable, ContactCellViewModel {
    let name: String
    let phone: String?
    let imageSource: ImageSource
    let uid: UniqueIdentifier
}
