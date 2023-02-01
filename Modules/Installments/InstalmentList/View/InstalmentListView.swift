//  Created by Lyudmila Danilchenko on 17/08/2020.

import ABUIComponents
import SnapKit

protocol InstalmentListViewDelegate: AnyObject {
    func pullToRefreshAction()
}

protocol DisplaysInstalmentListView: DisplaysDefaultContentState {
    func reloadTableView()
    func endRefreshing()
    var stateView: DisplaysDefaultContentState { get set }
}

final class InstalmentListView: UIView {
    // MARK: - Properties

    private let appearance = Appearance()

    weak var delegate: InstalmentListViewDelegate?

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        return tableView
    }()

    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.attributedTitle = nil
        control.addTarget(self, action: #selector(self.refreshControlAction), for: .valueChanged)
        return control
    }()

    // MARK: DisplaysInstalmentListView

    lazy var stateView: DisplaysDefaultContentState = InstalmentStateView()

    // MARK: - Lifecycle

    required init(
        delegate: InstalmentListViewDelegate?
    ) {
        self.delegate = delegate

        super.init(frame: .zero)
        addSubviews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configureTableView(with manager: UITableViewDelegate & UITableViewDataSource) {
        tableView.addSubview(refreshControl)

        tableView.dataSource = manager
        tableView.delegate = manager

        tableView.backgroundColor = appearance.palette.backgroundPrimary
    }

    @objc
    private func refreshControlAction() {
        delegate?.pullToRefreshAction()
    }
}

// MARK: - DisplaysInstalmentListView

extension InstalmentListView: DisplaysInstalmentListView {
    func endRefreshing() {
        refreshControl.endRefreshing()
    }

    func reloadTableView() {
        tableView.reloadData()
    }

    func showState(_ state: StyledContentState<DefaultEmptyViewRepresentable>) {
        stateView.showState(state)
        switch state {
        case .default:
            stateView.isHidden = true
        default:
            stateView.isHidden = false
        }
    }
}

// MARK: - Private

private extension InstalmentListView {
    struct Appearance: Grid, Theme { }

    func addSubviews() {
        addSubview(tableView)
        addSubview(stateView)
    }

    func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
