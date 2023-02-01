protocol BuildsCardNumber {
    func buildCardNumber(from maskedNumber: String) -> String
}

final class ShortCardNumberBuilder: BuildsCardNumber {
    private let remainingDigitsCount = 4
    func buildCardNumber(from maskedNumber: String) -> String {
        guard maskedNumber.length >= remainingDigitsCount else {
            return .empty
        }

        return String(maskedNumber.dropFirst(maskedNumber.length - remainingDigitsCount))
    }
}
