// Created by Станислав on 16.02.2023.

protocol ShareholderDetailsPresentationLogic: AnyObject {
    func presentShareholderDetails(_ response: ShareholderDetailsDataFlow.PresentShareholderDetails.Response)
}

final class ShareholderDetailsPresenter: ShareholderDetailsPresentationLogic {
    // MARK: - Internal Properties
    
    weak var viewController: ShareholderDetailsDisplayLogic?
    
    // MARK: - ShareholderDetailsPresentationLogic
    
    func presentShareholderDetails(_ response: ShareholderDetailsDataFlow.PresentShareholderDetails.Response) {
        let cellViewModel = ShareholderCellViewModel(
            name: response.shareholderDetails.name,
            phone: response.shareholderDetails.company.rawValue,
            imageSource: .image(.assets.art_logoAlfa_color),
            uid: response.shareholderDetails.id
        )
        viewController?.displayShareholderDetails(.init(shareholderDetails: cellViewModel))
    }
}
