import AlfaNetworking
import TestAdditions

@testable import CardReissue

final class CardReissueBeforeSuiteTests: QuickSpec {
    override func spec() {
        beforeSuite {
            APIClientRegister.setup()
        }
    }
}
