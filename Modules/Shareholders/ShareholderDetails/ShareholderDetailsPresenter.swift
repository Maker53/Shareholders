// Created by Станислав on 16.02.2023.

protocol ShareholderDetailsPresentationLogic: AnyObject { }

final class ShareholderDetailsPresenter: ShareholderDetailsPresentationLogic {
    // MARK: - Internal Properties
    
    weak var viewController: ShareholderDetailsDisplayLogic?
}
