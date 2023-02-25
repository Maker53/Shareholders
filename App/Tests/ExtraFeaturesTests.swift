import AlfaFoundation
import Shareholders
import TestAdditions

@testable import AlfaOnboarding

final class ExtraFeaturesTests: QuickSpec {
    override func spec() {
        describe(".setup") {
            it("should register extra feature types") {
                // given
                let primaryValues = Set(Feature.allCases.lazy.map(\.rawValue))
                let expectedAllValues = primaryValues.union(TestData.extraValues)
                // when
                let allValues = Set(AnyFeature.allCases.lazy.map { $0.rawValue })
                // then
                expect(allValues).to(equal(expectedAllValues))
            }
        }
    }
}

private extension ExtraFeaturesTests {
    enum TestData {
        static let extraValues = Set<String>()
            .union(values(of: ShareholdersFeature.self))

        static func values<Flag: FeatureFlag>(of flagType: Flag.Type) -> Set<Flag.RawValue> {
            Set(flagType.allCases.lazy.map(\.rawValue))
        }
    }
}
