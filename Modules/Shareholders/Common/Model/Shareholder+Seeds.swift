// Created by Станислав on 08.02.2023.

import SharedProtocolsAndModels

extension Shareholder {
    enum Seeds {
        static let value = Shareholder(
            id: "10",
            iconURL: "https://avatar.ru",
            name: "Nikita Petrov",
            company: Company.Seeds.value,
            amount: Amount(value: 754358880, minorUnits: 100, currency: "RUR"),
            profit: 0.3
        )
        
        static let valueCompanyUnknown = Shareholder(
            id: "10",
            iconURL: "https://avatar.ru",
            name: "Nikita Petrov",
            company: Company.Seeds.valueCompanyUnknown,
            amount: Amount(value: 754358880, minorUnits: 100, currency: "RUR"),
            profit: 0.3
        )
    }
}
