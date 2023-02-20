// Created by Станислав on 07.02.2023.

import AlfaFoundation
import ABUIComponents
import SharedRouter

protocol ShareholderListDisplayLogic: AnyObject {
    func displayShareholedList(_ viewModel: ShareholderListDataFlow.PresentShareholderList.ViewModel)
    func displayShareholderDetails(_ viewModel: ShareholderListDataFlow.PresentShareholderDetails.ViewModel)
}

public final class ShareholderListViewController<Routes: ShareholderListRoutes>: UIViewController, Navigates {
    // MARK: - Appearance
    
    private let appearance = Appearance()
    private struct Appearance: Theme {
        let backgroundColor = Palette.backgroundPrimary
    }
    
    // MARK: - View
    
    lazy var contentView: DisplayShareholderListView = {
        let view = ShareholderListView(delegate: self)
        return view
    }()
    
    // MARK: - Internal Properties
    
    let interactor: ShareholderListBusinessLogic
    
    // MARK: - Initializer
    
    required init(interactor: ShareholderListBusinessLogic) {
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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        interactor.fetchShareholderList()
    }
}

// MARK: - ShareholderListDisplayLogic

extension ShareholderListViewController: ShareholderListDisplayLogic {
    func displayShareholedList(_ viewModel: ShareholderListDataFlow.PresentShareholderList.ViewModel) {
        contentView.configure(viewModel)
    }
    
    func displayShareholderDetails(_ viewModel: ShareholderListDataFlow.PresentShareholderDetails.ViewModel) {
        navigate(to: Routes.shareholderDetails(uid: viewModel.uid))
    }
}

// MARK: - ShareholderListViewDelegate

extension ShareholderListViewController: ShareholderListViewDelegate {
    func didSelectShareholder(_ uid: UniqueIdentifier) {
        interactor.openShareholderDetails(.init(uid: uid))
    }
}
