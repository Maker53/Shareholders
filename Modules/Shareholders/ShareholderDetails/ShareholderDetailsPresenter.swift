// Created by Станислав on 16.02.2023.

import SharedProtocolsAndModels

protocol ShareholderDetailsPresentationLogic: AnyObject {
    func presentShareholderDetails(_ response: ShareholderDetailsDataFlow.PresentShareholderDetails.Response)
}

final class ShareholderDetailsPresenter: ShareholderDetailsPresentationLogic {
    // MARK: - Internal Properties
    
    weak var viewController: ShareholderDetailsDisplayLogic?
    let featuresService: FeaturesServiceProtocol
    
    // MARK: - Initializer
    
    init(featureService: FeaturesServiceProtocol) {
        self.featuresService = featureService
    }
    
    // MARK: - ShareholderDetailsPresentationLogic
    
    func presentShareholderDetails(_ response: ShareholderDetailsDataFlow.PresentShareholderDetails.Response) {
        viewController?.displayShareholderDetails(.init(shareholderDetails: getCellViewModel(response)))
    }
}

// MARK: - Private

private extension ShareholderDetailsPresenter {
    func getCellViewModel(_ response: ShareholderDetailsDataFlow.PresentShareholderDetails.Response) -> ShareholderCellViewModel {
        let isFeatureEnabled = featuresService.enabled(ShareholdersFeature.swapShareholderAndCompanyName)
        let name = isFeatureEnabled ? response.shareholderDetails.company.rawValue : response.shareholderDetails.name
        let companyName = isFeatureEnabled ? response.shareholderDetails.name : response.shareholderDetails.company.rawValue
        
        return ShareholderCellViewModel(
            name: name,
            phone: companyName,
            imageSource: .image(.assets.art_logoAlfa_color),
            uid: response.shareholderDetails.id
        )
    }
}
