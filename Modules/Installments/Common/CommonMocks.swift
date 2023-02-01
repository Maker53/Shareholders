import ABUIComponents
import SharedProtocolsAndModels

final class BuildsCardNumberMock: BuildsCardNumber {
    // MARK: - buildCardNumber

    private(set) var buildCardNumberFromWasCalled: Int = 0
    private(set) var buildCardNumberFromReceivedMaskedNumber: String?
    var buildCardNumberFromStub: String!

    func buildCardNumber(from maskedNumber: String) -> String {
        buildCardNumberFromWasCalled += 1
        buildCardNumberFromReceivedMaskedNumber = maskedNumber
        return buildCardNumberFromStub
    }
}

final class BuildsSkinImageSourceMock: BuildsSkinImageSource {
    // MARK: - buildSkinImageSource

    private(set) var buildSkinImageSourceSkinURIPlaceholderWasCalled: Int = 0
    private(set) var buildSkinImageSourceSkinURIPlaceholderReceivedArguments: (skinURI: String?, placeholder: UIImage)?
    var buildSkinImageSourceSkinURIPlaceholderStub: ImageSource!

    func buildSkinImageSource(skinURI: String?, placeholder: UIImage) -> ImageSource {
        buildSkinImageSourceSkinURIPlaceholderWasCalled += 1
        buildSkinImageSourceSkinURIPlaceholderReceivedArguments = (skinURI: skinURI, placeholder: placeholder)
        return buildSkinImageSourceSkinURIPlaceholderStub
    }
}
