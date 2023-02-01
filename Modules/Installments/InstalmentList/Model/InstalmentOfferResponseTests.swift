// Created by Андрей Фокин on 12.10.2022.

import TestAdditions

@testable import Installments

final class InstalmentOfferResponseTests: QuickSpec {
    override func spec() {
        describe(".decode") {
            it("should decode from JSON") {
                // then
                expect(TestData.json).to(equalDecodingRepresentation(TestData.model))
            }
        }
    }
}

private extension InstalmentOfferResponseTests {
    enum TestData {
        static let model = InstalmentOfferResponse(
            instalmentOffers: [InstalmentOffer.Seeds.valueWithNoAccount],
            shouldShowLanding: true
        )
        static let json = """
        {
          "instalmentOffers" : [
            {
              "hasInstallmentBaseAgreement" : false,
              "id" : "70000875685",
              "offerType" : "Promotional",
              "banner" : {
                "title" : "Test banner"
              }
            }
          ],
          "showLanding" : true
        }
        """
    }
}
