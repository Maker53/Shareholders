// Created by Станислав on 17.02.2023.

import ABUIComponents
import SharedProtocolsAndModels

extension ShareholderCellViewModel {
    enum Seeds {
        static let value = ShareholderCellViewModel(
            name: "Nikita Petrov",
            phone: "Alfabank",
            imageSource: .image(.assets.art_logoAlfa_color),
            uid: .init("1")
        )
        
        static let valueCompanyUnknown = ShareholderCellViewModel(
            name: "Nikita Petrov",
            phone: "unknown",
            imageSource: .image(.assets.art_logoAlfa_color),
            uid: .init("2")
        )
        
        static let valueLongNames = ShareholderCellViewModel(
            name: "TestName_TestName_TestName_TestName_TestName_TestName",
            phone: "TestCompanyName_TestCompanyName_TestCompanyName",
            imageSource: .image(.assets.art_logoAlfa_color),
            uid: .init("3")
        )
        
        static let swappedValue = ShareholderCellViewModel(
            name: "Alfabank",
            phone: "Nikita Petrov",
            imageSource: .image(.assets.art_logoAlfa_color),
            uid: .init("1")
        )
    }
}
