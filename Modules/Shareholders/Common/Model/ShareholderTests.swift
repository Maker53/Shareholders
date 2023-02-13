// Created by Станислав on 09.02.2023.

import TestAdditions
@testable import Shareholders

final class ShareholderTests: QuickSpec {
    override func spec() {
        describe(".decode") {
            it("should decode from JSON") {
                // then
                expect(TestData.json).to(equalDecodingRepresentation(TestData.model))
            }
        }
    }
}

// MARK: - TestData

private extension ShareholderTests {
    enum TestData {
        static let model = Shareholder.Seeds.value
        static let json = """
        {
            "id": "10",
            "iconURL": "https://avatar.ru",
            "name": "Nikita Petrov",
            "company": "Alfabank",
            "amount": {
                "value": 754358880,
                "currency": "RUR",
                "minorUnits": 100
            },
            "profit": 0.3
        }
        """
    }
}
