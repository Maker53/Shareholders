//  Created by Lyudmila Danilchenko on 25/10/2020.

import SharedRouter
import SnapKit

protocol InstalmentDetailDisplayLogic: AnyObject {
    func displayData(_ viewModel: InstalmentDetail.PresentModuleData.ViewModel)
        
    func displayTransfer()
    func infoDialogAction()
    func displayCancelInstalment(_ viewModel: InstalmentDetail.PresentCancelInstalment.ViewModel)
}

public final class InstalmentDetailViewController<Routes: InstalmentDetailRoutes>: UIViewController, Navigates {
    // MARK: - Views

    lazy var contentView: DisplaysInstalmentDetailView = {
        let contentView = InstalmentDetailView(delegate: self)
        contentView.configureTableView(with: tableManager)
        return contentView
    }()

    // MARK: - Properties

    let interactor: InstalmentDetailBusinessLogic
    let tableManager: ManagesInstalmentDetailTable
    let analytics: InstalmentDetailEvents

    // MARK: - Lifecycle

    required init(
        analytics: InstalmentDetailEvents,
        interactor: InstalmentDetailBusinessLogic,
        tableManager: ManagesInstalmentDetailTable = InstalmentDetailTableManager()
    ) {
        self.analytics = analytics
        self.interactor = interactor
        self.tableManager = tableManager
        super.init(nibName: nil, bundle: nil)

        self.tableManager.delegate = self
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override public func loadView() {
        view = contentView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        analytics.trackScreen()
        configureNavigationItem()
        contentView.showState(.waiting)
        interactor.loadData()
    }
}

// MARK: - InstalmentDetailDisplayLogic

extension InstalmentDetailViewController: InstalmentDetailDisplayLogic {
    func displayData(_ viewModel: InstalmentDetail.PresentModuleData.ViewModel) {
        contentView.showState(.default)

        tableManager.sections = viewModel.sections
        contentView.configure(viewModel)
        contentView.setupHeader(viewModel.title)
        contentView.reloadTableView()
    }

    func displayTransfer() {
        navigate(to: Routes.transfer(source: nil, destination: nil))
    }

    func displayCancelInstalment(_ viewModel: InstalmentDetail.PresentCancelInstalment.ViewModel) {
        navigate(to: Routes.cancelInstallment(with: viewModel.cancelInstallmentContext))
    }
}

// MARK: - DisplaysInstalmentDetailViewDelegate

extension InstalmentDetailViewController: DisplaysInstalmentDetailViewDelegate {
    func repaymentButtonClicked() {
        analytics.trackButtonTap()
    }
}

// MARK: - InstalmentDetailTableManagerDelegate

extension InstalmentDetailViewController: InstalmentDetailTableManagerDelegate {
    func didTapCancelBanner() {
        interactor.openCancelInstallment()
    }

    func didTapRepaymentInfo() {
        interactor.openInfoDialog()
    }
}

extension InstalmentDetailViewController {
    func infoDialogAction() {
        interactor.openTransfer()
    }
}
