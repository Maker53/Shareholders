//  Created by Vitaliy Ramazanov on 10/02/2021.

import ABUIComponents
import SharedProtocolsAndModels
import TestAdditions

@testable import Installments

final class SkinImageSourceBuilderTests: QuickSpec {
    override func spec() {
        var builder: SkinImageSourceBuilder!

        beforeEach {
            builder = .init()
        }

        describe(".buildSkingImageSource") {
            context("when skin uri is correct") {
                it("should return correct imagesource") {
                    let icon = builder.buildSkinImageSource(
                        skinURI: TestData.correctCardSkinURI,
                        placeholder: TestData.placeholder
                    )

                    let expectedResult = ImageSource.url(
                        TestData.correctURL,
                        placeholder: TestData.placeholder
                    )

                    expect(icon).to(equal(expectedResult))
                }

                it("should return correct imagesource") {
                    let icon = builder.buildSkinImageSource(
                        skinURI: TestData.correctCardSinURIWithParams,
                        placeholder: TestData.placeholder
                    )

                    let expectedResult = ImageSource.url(
                        TestData.correctURL,
                        placeholder: TestData.placeholder
                    )

                    expect(icon).to(equal(expectedResult))
                }

                it("should return correct imagesource") {
                    let icon = builder.buildSkinImageSource(
                        skinURI: TestData.correctCardSinURIWithParamInFront,
                        placeholder: TestData.placeholder
                    )

                    let expectedResult = ImageSource.url(
                        TestData.correctURL,
                        placeholder: TestData.placeholder
                    )

                    expect(icon).to(equal(expectedResult))
                }
            }

            context("when skin uri is correct") {
                it("should return correct imagesource") {
                    let icon = builder.buildSkinImageSource(
                        skinURI: TestData.incorrectCardSkinURI,
                        placeholder: TestData.placeholder
                    )

                    expect(icon).to(equal(.image(TestData.placeholder)))
                }
            }
        }
    }
}

private extension SkinImageSourceBuilderTests {
    enum TestData {
        static let correctURL = URL(
            unwrapped: "https://online.alfabank.ru/cards-images/cards/I0/images?layers=BACKGROUND,LOGO,PAYMENT_SYSTEM"
        )

        static let correctCardSkinURI =
            "https://online.alfabank.ru/cards-images/cards/I0/images?layers=BACKGROUND,LOGO,PAYMENT_SYSTEM"
        static let correctCardSinURIWithParams =
            "https://online.alfabank.ru/cards-images/cards/I0/images?layers=BACKGROUND,LOGO,PAYMENT_SYSTEM&width=%d"
        static let correctCardSinURIWithParamInFront =
            "https://online.alfabank.ru/cards-images/cards/I0/images?width=%d&layers=BACKGROUND,LOGO,PAYMENT_SYSTEM"

        static let incorrectCardSkinURI = "Incorrect URL :("

        static let placeholder = UIImage.assetsCatalog.account_card_image_placeholder
    }
}
