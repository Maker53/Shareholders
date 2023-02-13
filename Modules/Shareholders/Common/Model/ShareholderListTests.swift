// Created by Станислав on 09.02.2023.

import TestAdditions
@testable import Shareholders

final class ShareholderListTests: QuickSpec {
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

private extension ShareholderListTests {
    enum TestData {
        static let model = ShareholderList.Seeds.values
        static let json = """
        {
            "values": [
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
                },
                {
                    "id": "10",
                    "iconURL": "https://avatar.ru",
                    "name": "Nikita Petrov",
                    "company": "unknown",
                    "amount": {
                        "value": 754358880,
                        "currency": "RUR",
                        "minorUnits": 100
                    },
                    "profit": 0.3
                }
            ]
        }
        """
    }
}
