//  Created by Lyudmila Danilchenko on 21.08.2020.

import AlfaNetworking
import SharedPromiseKit

protocol ProvidesInstalmentList {
    func getInstalments(installmentType: InstallmentType, usingCache: Bool) -> Promise<[Instalment]>
    func getInstalmentOffers(context: InstallmentOfferContext) -> Promise<InstalmentOfferResponse>
}

final class InstalmentListProvider: ProvidesInstalmentList {
    let dataStore: StoresInstalmentList
    let service: InstalmentListServiceType
    let serviceOffer: InstalmentOfferServiceType

    init(
        dataStore: StoresInstalmentList = InstalmentListDataStore(),
        service: InstalmentListServiceType,
        serviceOffer: InstalmentOfferServiceType
    ) {
        self.dataStore = dataStore
        self.service = service
        self.serviceOffer = serviceOffer
    }

    // MARK: - ProvidesInstalmentList

    func getInstalments(installmentType: InstallmentType, usingCache: Bool = true) -> Promise<[Instalment]> {
        if usingCache, let installments = dataStore.instalmentListModelWithType[installmentType]??.instalments {
            return .value(installments)
        }

        return service
            .sendRequest(pathContext: installmentType)
            .get { [weak self] in
                self?.dataStore.instalmentListModelWithType[installmentType] = .init(instalments: $0)
            }
    }

    func getInstalmentOffers(context: InstallmentOfferContext) -> Promise<InstalmentOfferResponse> {
        if let responseModel = dataStore.instalmentOffersModelWithType[context.installmentType], let offerResponse = responseModel {
            return .value(offerResponse)
        }

        return serviceOffer
            .sendRequest(pathContext: context)
            .get { [weak self] in
                self?.dataStore.instalmentOffersModelWithType[context.installmentType] = $0
            }
    }
}
