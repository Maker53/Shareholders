// Created by Станислав on 16.02.2023.

import AlfaFoundation
import ABUIComponents
import SharedRouter

protocol ShareholderDetailsDisplayLogic: AnyObject {
    func displayShareholderDetails(_ viewModel: ShareholderDetailsDataFlow.PresentShareholderDetails.ViewModel)
}

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
    let shareholderUid: UniqueIdentifier
    
    // MARK: - Initializer
    
    required init(interactor: ShareholderDetailsBusinessLogic, uid: UniqueIdentifier) {
        self.interactor = interactor
        shareholderUid = uid
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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor.fetchShareholderDetails(.init(uid: shareholderUid))
    }
}

// MARK: - ShareholderDetailsDisplayLogic

extension ShareholderDetailsViewController: ShareholderDetailsDisplayLogic {
    func displayShareholderDetails(_ viewModel: ShareholderDetailsDataFlow.PresentShareholderDetails.ViewModel) {
        contentView.configure(viewModel)
    }
}
