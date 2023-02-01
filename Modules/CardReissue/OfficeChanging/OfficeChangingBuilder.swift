///  Created by Roman Turov on 16/04/2019

import AlfaFoundation

public class OfficeChangingBuilder: ModuleBuilder {
    var routes: OfficeChangingRoutes.Type?
    var cardID: String?
    var delegateBlock: (() -> Void)?

    public init() { }

    public func setRoutes(_ routes: OfficeChangingRoutes.Type?) -> Self {
        self.routes = routes
        return self
    }

    public func setCardID(_ cardID: String) -> Self {
        self.cardID = cardID
        return self
    }

    public func setDelegateBlock(_ delegateBlock: (() -> Void)?) -> Self {
        self.delegateBlock = delegateBlock
        return self
    }

    public func build() -> OfficeChangingViewController {
        guard
            let routes = routes,
            let cardID = cardID
        else { preconditionFailure("Parameters were not set") }

        let provider = OfficeChangingProvider()
        let presenter = OfficeChangingPresenter()
        let interactor = OfficeChangingInteractor(cardID: cardID, presenter: presenter, provider: provider)
        let controller = OfficeChangingViewController(interactor: interactor, routes: routes, delegateBlock: delegateBlock)
        presenter.viewController = controller
        return controller
    }
}
