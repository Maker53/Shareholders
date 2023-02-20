// Created by Станислав on 07.02.2023.

protocol ShareholderListPresentationLogic: AnyObject {
    func presentShareholderList(_ response: ShareholderListDataFlow.PresentShareholderList.Response)
}

final class ShareholderListPresenter: ShareholderListPresentationLogic {
    // MARK: - Internal Properties
    
    weak var viewController: ShareholderListDisplayLogic?
    
    // MARK: - ShareholderListPresentationLogic
    
    func presentShareholderList(_ response: ShareholderListDataFlow.PresentShareholderList.Response) {
        let rows = response.shareholders.values.map {
            ShareholderListCellViewModel(
                name: $0.name,
                phone: $0.company.rawValue,
                imageSource: .image(.assets.art_logoAlfa_color)
            )
        }
        
        viewController?.displayShareholedList(.init(rows: rows))
    }
}
