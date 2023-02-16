// Created by Станислав on 16.02.2023.

import ABUIComponents
import SharedRouter

protocol ShareholderDetailsDisplayLogic: AnyObject { }

public final class ShareholderDetailsViewController<Routes: ShareholderDetailsRoutes>: UIViewController, Navigates {
    // MARK: - Appearance
    
    private let appearance = Appearance()
    private struct Appearance: Theme {
        let backgroundColor = Palette.backgroundPrimary
    }
    
    // MARK: - View
    
    lazy var contentView: DisplaysShareholderDetailsView = {
        let view = ShareholderDetailsView()
        return view
    }()
    
    // MARK: - Internal Properties
    
    let interactor: ShareholderDetailsBusinessLogic
    
    // MARK: - Initializer
    
    required init(interactor: ShareholderDetailsBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    public override func loadView() {
        view = contentView
        view.backgroundColor = appearance.backgroundColor
    }
}

// MARK: - ShareholderDetailsDisplayLogic

extension ShareholderDetailsViewController: ShareholderDetailsDisplayLogic { }
