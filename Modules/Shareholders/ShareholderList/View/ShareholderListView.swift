// Created by Станислав on 07.02.2023.

import ABUIComponents
import SnapKit

protocol DisplayShareholderListView: UIView {
    func configure(_ viewModel: ShareholderListDataFlow.PresentShareholderList.ViewModel)
}

protocol ShareholderListViewDelegate: AnyObject { }

final class ShareholderListView: UIView {
    // MARK: - Views
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = tableManager
        tableView.backgroundColor = appearance.palette.backgroundPrimary
        return tableView
    }()
    
    // MARK: - Internal Properties
    
    weak var delegate: ShareholderListViewDelegate?
    let tableManager: ShareholderListTableManagerProtocol
    
    // MARK: - Private Properties
    
    private let appearance = Appearance()
    
    // MARK: - Initializers
    
    required init(delegate: ShareholderListViewDelegate?, tableManager: ShareholderListTableManagerProtocol) {
        self.delegate = delegate
        self.tableManager = tableManager
        super.init(frame: .zero)
        
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DisplayShareholderListView

extension ShareholderListView: DisplayShareholderListView {
    func configure(_ viewModel: ShareholderListDataFlow.PresentShareholderList.ViewModel) {
        tableManager.rows = viewModel.rows
        tableView.reloadData()
    }
}

// MARK: - Private

private extension ShareholderListView {
    struct Appearance: Theme { }
    
    func addSubviews() {
        add(subviews: tableView)
    }
    
    func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
