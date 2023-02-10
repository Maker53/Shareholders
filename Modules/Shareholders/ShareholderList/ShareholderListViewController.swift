// Created by Станислав on 07.02.2023.

import ABUIComponents
import SharedRouter

protocol ShareholderListDisplayLogic: AnyObject {
    func displayShareholedList(_ viewModel: ShareholderListDataFlow.PresentShareholderList.ViewModel)
}

public final class ShareholderListViewController<Routes: ShareholderListRoutes>: UIViewController, Navigates {
    // MARK: - Appearance
    
    private let appearance = Appearance()
    private struct Appearance: Theme {
        let backgroundColor = Palette.backgroundPrimary
    }
    
    // MARK: - View
    
    lazy var contentView: ShareholderListView = {
        let view = ShareholderListView(delegate: self, tableManager: ShareholderListTableManager())
        return view
    }()
    
    // MARK: - Private Properties
    
    private let interactor: ShareholderListBusinessLogic
    
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
        interactor.fetchShareholderList(.init())
    }
}

// MARK: - ShareholderListDisplayLogic

extension ShareholderListViewController: ShareholderListDisplayLogic {
    func displayShareholedList(_ viewModel: ShareholderListDataFlow.PresentShareholderList.ViewModel) { }
}

// MARK: - ShareholderListViewDelegate

extension ShareholderListViewController: ShareholderListViewDelegate { }
