import TestAdditions
@testable import Installments

final class CardNumberBuilderTests: QuickSpec {
    override func spec() {
        var builder: ShortCardNumberBuilder!

        beforeEach {
            builder = ShortCardNumberBuilder()
        }

        describe(".buildCardNumber") {
            context("when masked number is longer than 4 digits") {
                it("should return 4 last digits") {
                    expect(builder.buildCardNumber(from: "1234 5678 9012 3456")).to(equal("3456"))
                }
            }
            context("when masked number is shorter than 4 digits") {
                it("should return empty string") {
                    expect(builder.buildCardNumber(from: "123")).to(equal(""))
                }
            }
            context("when masked number consists of 4 digits") {
                it("should return 4 digits long number") {
                    expect(builder.buildCardNumber(from: "1234")).to(equal("1234"))
                }
            }
        }
    }
}
