// Created by Станислав on 17.02.2023.

import ABUIComponents
import SharedProtocolsAndModels

extension ShareholderListCellViewModel {
    enum Seeds {
        static let value = ShareholderListCellViewModel(
            name: "Nikita Petrov",
            phone: "Alfabank",
            imageSource: .image(.assets.art_logoAlfa_color),
            uid: .init("1")
        )
        
        static let valueCompanyUnknown = ShareholderListCellViewModel(
            name: "Nikita Petrov",
            phone: "unknown",
            imageSource: .image(.assets.art_logoAlfa_color),
            uid: .init("2")
        )
        
        static let valueLongNames = ShareholderListCellViewModel(
            name: "TestName_TestName_TestName_TestName_TestName_TestName",
            phone: "TestCompanyName_TestCompanyName_TestCompanyName",
            imageSource: .image(.assets.art_logoAlfa_color),
            uid: .init("3")
        )
    }
}
