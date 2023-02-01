//  Created by Lyudmila Danilchenko on 17/08/2020.

import ABUIComponents
import SharedProtocolsAndModels
import SharedRouter
import SnapKit

protocol InstalmentListDisplayLogic: AnyObject {
    func displayInstalments(_ viewModel: InstalmentList.PresentModuleData.ViewModel)
    func displayError(_ viewModel: InstalmentList.LoadingError.ViewModel)
    func displayPlusButton(_ viewModel: InstalmentList.PresentPlusButton.ViewModel)
    func displayEmptyView(_ viewModel: InstalmentList.PresentEmptyState.ViewModel)
    func displayNewInstalment(_ viewModel: InstalmentList.PresentNewInstalmentData.ViewModel)
    func displayNewInstallmentSelection(_ viewModel: InstalmentList.PresentNewInstalmentSelection.ViewModel)
    func displayInstallmentDetails(_ viewModel: InstalmentList.PresentInstallmentDetails.ViewModel)
    func dismiss()
}

public final class InstalmentListViewController<Routes: InstalmentListRoutes>: UIViewController, Navigates {
    // MARK: - Appearance

    private let appearance = Appearance()
    private struct Appearance: Theme, Grid {
        let backgroundColor = Palette.backgroundPrimary
    }

    // MARK: - Views

    lazy var contentView: DisplaysInstalmentListView = {
        let contentView = InstalmentListView(delegate: self)
        contentView.configureTableView(with: tableManager)
        return contentView
    }()

    // MARK: - Properties

    let interactor: InstalmentListBusinessLogic
    let tableManager: ManagesInstalmentListTable
    private let analytics: InstalmentListEvents

    // MARK: - Lifecycle

    required init(
        analytics: InstalmentListEvents,
        interactor: InstalmentListBusinessLogic,
        tableManager: ManagesInstalmentListTable = InstalmentListTableManager()
    ) {
        self.analytics = analytics
        self.interactor = interactor
        self.tableManager = tableManager
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override public func loadView() {
        view = contentView
        view.backgroundColor = appearance.backgroundColor
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        customTitle = L10n.InstalmentList.title
        edgesForExtendedLayout = [.bottom]
        configureNavigationItem()
        configureNavigationBar()
        tableManager.delegate = self
        contentView.showState(.waiting)
        interactor.loadData(.init(shouldRefreshInstalments: false))
    }

    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.createAccessibleButton(
            target: self,
            action: #selector(backButtonPressed)
        )
    }

    // MARK: - Action

    @objc
    func plusTapped() {
        interactor.openNewInstalment()
    }

    @objc
    func backButtonPressed() {
        navigate(to: Routes.back())
    }

    func newInstalmentButtonPressed() {
        interactor.openNewInstalment()
    }
}

// MARK: - InstalmentListDisplayLogic

extension InstalmentListViewController: InstalmentListDisplayLogic {
    func displayNewInstallmentSelection(_ viewModel: InstalmentList.PresentNewInstalmentSelection.ViewModel) {
        navigate(
            to: Routes.alert(
                text: .standard(title: nil, message: nil),
                actions: viewModel.actions,
                style: .actionSheet(.standard(sourceRect: .zero, sourceView: view))
            )
        )
    }

    func displayNewInstalment(_ viewModel: InstalmentList.PresentNewInstalmentData.ViewModel) {
        // TODO:
    }

    func displayError(_ viewModel: InstalmentList.LoadingError.ViewModel) {
        analytics.trackError(viewModel.description)
        contentView.showState(.empty(viewModel.model))
    }

    func displayInstalments(_ viewModel: InstalmentList.PresentModuleData.ViewModel) {
        analytics.trackScreen()
        tableManager.sections = viewModel.sections
        contentView.showState(.default)
        contentView.reloadTableView()
        contentView.endRefreshing()
    }

    func displayPlusButton(_ viewModel: InstalmentList.PresentPlusButton.ViewModel) {
        navigationItem.rightBarButtonItem = viewModel.shouldPresentButton
            ? UIBarButtonItem(
                image: UIImage.assets.glyph_addLarge_m.withRenderingMode(.alwaysTemplate),
                style: .plain,
                target: self,
                action: #selector(plusTapped)
            )
            : nil
        navigationItem.rightBarButtonItem?.accessibilityLabel = L10n.InstalmentList.Accessibility.newInstalment
    }

    func displayEmptyView(_ viewModel: InstalmentList.PresentEmptyState.ViewModel) {
        var newModel = viewModel.emptyViewViewModel
        newModel.firstButtonViewModel?.buttonHandler = { [weak self] _ in
            self?.newInstalmentButtonPressed()
        }

        contentView.showState(.empty(newModel))
    }

    func displayInstallmentDetails(_ viewModel: InstalmentList.PresentInstallmentDetails.ViewModel) {
        navigate(to: Routes.instalmentDetails(with: viewModel))
    }

    func dismiss() {
        backButtonPressed()
    }
}

// MARK: - PreferredNavigationBarStyle

extension InstalmentListViewController: PreferredNavigationBarStyle {
    public var navigationBarStyle: NavigationBarStyle {
        BaseNavigationBarStyle.base
    }
}

// MARK: - InstalmentListViewDelegate

extension InstalmentListViewController: InstalmentListViewDelegate {
    func pullToRefreshAction() {
        interactor.loadData(.init(shouldRefreshInstalments: true))
    }
}

// MARK: - InstalmentListTableManagerDelegate

extension InstalmentListViewController: InstalmentListTableManagerDelegate {
    func didSelectInstalment(_ instalment: Instalment, type: InstallmentType) {
        interactor.openInstallmentDetails(.init(installment: instalment, installmentType: type))
    }
}
