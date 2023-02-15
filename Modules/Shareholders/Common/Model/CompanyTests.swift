// Created by Станислав on 13.02.2023.

import TestAdditions
@testable import Shareholders

final class CompanyTests: QuickSpec {
    override func spec() {
        describe(".init") {
            context("when the company name is correct in JSON") {
                it("should init with company name case") {
                    // then
                    expect(TestData.knownCompanyName)
                        .to(equalDecodingRepresentation(TestData.knownCompanyModel))
                }
            }
            
            context("when the company name is unknown in JSON") {
                it("should init with unknown case") {
                    // then
                    expect(TestData.uknownCompanyName)
                        .to(equalDecodingRepresentation(TestData.uknownCompanyModel))
                }
            }
        }
    }
}

// MARK: - TestData

private extension CompanyTests {
    enum TestData {
        static let knownCompanyModel = Company.Seeds.value
        static let uknownCompanyModel = Company.Seeds.valueCompanyUnknown
        static let knownCompanyName = "Alfabank"
        static let uknownCompanyName = "Raif"
    }
}
