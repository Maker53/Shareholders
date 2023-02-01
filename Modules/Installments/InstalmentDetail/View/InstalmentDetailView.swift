//  Created by Lyudmila Danilchenko on 25/10/2020.

import ABUIComponents
import SnapKit

typealias PrimaryMainButton = MainButton<MainButtonStyle.Primary>

protocol DisplaysInstalmentDetailViewDelegate: AnyObject {
    func repaymentButtonClicked()
}

protocol DisplaysInstalmentDetailView: UIView & ContentStateView {
    func configure(_ viewModel: InstalmentDetail.PresentModuleData.ViewModel)
    func reloadTableView()
    func setupHeader(_: String)
}

final class InstalmentDetailView: UIView {
    // MARK: - Properties

    private let appearance = Appearance()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.backgroundColor = appearance.palette.backgroundPrimary
        tableView.contentInset.bottom = appearance.contentInset
        return tableView
    }()

    private(set) lazy var repaymentButton: PrimaryMainButton = {
        let button = PrimaryMainButton()
        button.setTitle(L10n.Installments.InstalmentDetail.payEarlyButton, for: .normal)
        button.addTarget(self, action: #selector(repaymentButtonAction), for: .touchUpInside)
        return button
    }()

    private weak var delegate: DisplaysInstalmentDetailViewDelegate?

    // MARK: - Lifecycle

    required init(delegate: DisplaysInstalmentDetailViewDelegate) {
        self.delegate = delegate

        super.init(frame: .zero)
        backgroundColor = appearance.backgroundColor
        addSubviews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configureTableView(with manager: UITableViewDelegate & UITableViewDataSource) {
        tableView.dataSource = manager
        tableView.delegate = manager
    }

    // MARK: - Actions

    @objc
    private func repaymentButtonAction() {
        delegate?.repaymentButtonClicked()
    }
}

// MARK: - ContentStateView

extension InstalmentDetailView: ContentStateView {
    public func styleForWaitingView() -> WaitingView.Style? { .lightWithBackground }
}

// MARK: - DisplaysInstalmentDetailView

extension InstalmentDetailView: DisplaysInstalmentDetailView {
    func configure(_ viewModel: InstalmentDetail.PresentModuleData.ViewModel) {
        repaymentButton.isHidden = viewModel.shouldHideRepayment
        repaymentButton.isEnabled = viewModel.shouldEnableRepayment
    }

    func reloadTableView() {
        tableView.reloadData()
    }

    func setupHeader(_ title: String) {
        let view = HeaderView<HeaderViewStyle.Heading3>(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: appearance.headerHeight))
        view.configure(with: DefaultHeaderViewViewModel(title: title))
        tableView.tableHeaderView = view
    }
}

// MARK: - Private

private extension InstalmentDetailView {
    struct Appearance: Grid, Theme {
        let backgroundColor = Palette.backgroundPrimary
        let headerHeight: CGFloat = 50
        var contentInset: CGFloat { xxxsSpace * InstalmentDetailView.Appearance.xxxl }
    }

    func addSubviews() {
        addSubview(tableView)
        addSubview(repaymentButton)
    }

    func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        repaymentButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(appearance.horizontalMargin)
            make.bottom.equalToSuperview().inset(appearance.sSpace)
        }
    }
}
