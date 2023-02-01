//
// InstalmentOfferResponse+Seeds
// Generated on 27/07/2021 by gen v0.6.11
//

import AlfaFoundation

extension InstalmentOfferResponse {
    enum Seeds {
        static let value = InstalmentOfferResponse(
            instalmentOffers: [InstalmentOffer.Seeds.value, InstalmentOffer.Seeds.value],
            shouldShowLanding: false
        )

        static let showLandingValue = InstalmentOfferResponse(
            instalmentOffers: [InstalmentOffer.Seeds.value, InstalmentOffer.Seeds.value],
            shouldShowLanding: true
        )

        static let emptyOfferTypeValue = InstalmentOfferResponse(
            instalmentOffers: [InstalmentOffer.Seeds.valueWithNoOfferType, InstalmentOffer.Seeds.valueWithNoOfferType],
            shouldShowLanding: true
        )

        static let emptyValue = InstalmentOfferResponse(instalmentOffers: [], shouldShowLanding: false)
    }
}
