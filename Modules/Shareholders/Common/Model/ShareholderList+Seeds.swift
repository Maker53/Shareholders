// Created by Станислав on 08.02.2023.

extension ShareholderList {
    enum Seeds {
        static let values = ShareholderList(
            values: [Shareholder.Seeds.value, Shareholder.Seeds.valueCompanyUnknown]
        )
    }
}
