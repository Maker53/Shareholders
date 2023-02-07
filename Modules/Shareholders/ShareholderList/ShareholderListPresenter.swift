// Created by Станислав on 07.02.2023.

protocol ShareholderListPresentationLogic: AnyObject {
    func presentShareholderList(_ response: ShareholderListDataFlow.PresentShareholderList.Response)
}

final class ShareholderListPresenter: ShareholderListPresentationLogic {
    // MARK: - Internal Properties
    
    weak var viewController: ShareholderListDisplayLogic?
    
    // MARK: - ShareholderListPresentationLogic
    
    func presentShareholderList(_ response: ShareholderListDataFlow.PresentShareholderList.Response) {
        viewController?.displayShareholedList(.init())
    }
}
