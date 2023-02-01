///  Created by Roman Turov on 16/04/2019.

import ABUIComponents
import AlfaFoundation
import SharedRouter
import SnapKit

protocol OfficeChangingBusinessLogic {
    func getCities()
    func openCitiesList()
    func selectCity(_ request: OfficeChanging.SelectCity.Request)
    func openMetroList()
    func selectMetro(_ request: OfficeChanging.SelectMetro.Request)
    func openOfficesList()
    func selectOffice(_ request: OfficeChanging.SelectOffice.Request)
    func updateReissuesOffice()
}

public class OfficeChangingViewController: UIViewController, Navigates {
    lazy var tableManager = OfficeChangingTableManager(delegate: self)
    lazy var contentView: OfficeChangingView = {
        let view = OfficeChangingView(delegate: self)
        view.tableView.dataSource = tableManager
        view.tableView.delegate = tableManager
        return view
    }()

    /// Блок, выполняющийся при сохранении нового отделения
    /// чтобы обновить информацию на экране с картой
    var delegateBlock: (() -> Void)?

    enum Configuration: Grid {
        static let maxOverplayPoint: CGFloat = 0.9
        static let rowHeight = gridUnitSize.height * xxxl
    }

    var pickerDataSource: OfficeChangingPickerDataSource?
    var routes: OfficeChangingRoutes.Type?

    let interactor: OfficeChangingBusinessLogic
    public var state = State()

    init(
        interactor: OfficeChangingBusinessLogic,
        routes: OfficeChangingRoutes.Type?,
        delegateBlock: (() -> Void)?
    ) {
        self.interactor = interactor
        self.routes = routes
        self.delegateBlock = delegateBlock
        super.init(nibName: nil, bundle: nil)
        legacyConfigureNavigationItem()
        customTitle = "CardReissue.OfficeChanging.ControllerTitle".localized() as String
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override public func loadView() {
        view = UIView()
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        updateState { $0.screenState = .loading }
        interactor.getCities()
    }
}

// MARK: - OfficeChangingDisplayLogic

extension OfficeChangingViewController: OfficeChangingDisplayLogic {
    func display(_ viewModel: OfficeChanging.PresentCells.ViewModel) {
        updateState {
            $0.screenState = .initial
            $0.viewModels = viewModel.pickerViewModels
        }
        contentView.confirmationButton.isEnabled = viewModel.isConfirmationButtonActive
    }

    func displayItemsList(_ viewModel: OfficeChanging.OpenItemsList.ViewModel) {
        presentScrollablePicker(
            with: viewModel.cells,
            initialSelectedItemIndex: viewModel.selectedItemIndex
        ) { [weak self] index in
            self?.updateState { $0.screenState = .loading }
            switch viewModel.presentedCellType {
            case .city:
                self?.interactor.selectCity(.init(index: index))
            case .metro:
                self?.interactor.selectMetro(.init(index: index))
            case .office:
                self?.interactor.selectOffice(.init(index: index))
            }
        }
    }

    func presentScrollablePicker(
        with viewModels: [OfficeChangingCellViewModel],
        initialSelectedItemIndex: Int?,
        selectionHandler: @escaping (Int) -> Void
    ) {
        pickerDataSource = OfficeChangingPickerDataSource(
            viewModels: viewModels,
            selectionHandler: selectionHandler
        )
        guard let dataSource = pickerDataSource else { return }
        let rowHeight = Configuration.rowHeight
        let contentHeight = rowHeight * CGFloat(viewModels.count + 1)
        let overlayPoint = contentHeight / contentView.frame.height
        let pickerViewController = ScrollablePickerViewController(
            dataSource: dataSource,
            initialSelectedItemIndex: initialSelectedItemIndex ?? -1,
            appearance: .init(overlayPart: min(overlayPoint, Configuration.maxOverplayPoint))
        )
        pickerViewController.tableView.rowHeight = UITableView.automaticDimension
        pickerViewController.tableView.estimatedRowHeight = Configuration.rowHeight
        pickerViewController.tableView.separatorStyle = .singleLine

        present(pickerViewController, animated: true, completion: nil)
    }

    func displayUpdatedReissuesOffice() {
        updateState { $0.screenState = .initial }
        delegateBlock?()
        navigate(to: routes?.back())
    }

    func displayError(_ error: OfficeChanging.ErrorType) {
        updateState { $0.screenState = .initial }
        if case .emptyState = error {
            contentView.showState(.empty(nil))
            return
        }
        navigate(to: routes?.alert(
            title: "Error".localized() as String,
            message: error.errorDescription ?? "CardReissue.SomethingWentWrong".localized() as String,
            actions: [UIAlertAction(title: "OK".localized() as String, style: .default, handler: nil)],
            style: .alert
        ))
    }
}

// MARK: - OfficeChangingTableDelegate

extension OfficeChangingViewController: OfficeChangingTableDelegate {
    func didSelectRow(_ row: OfficeChangingRowType) {
        switch row {
        case .city:
            interactor.openCitiesList()
        case .metro:
            interactor.openMetroList()
        case .office:
            interactor.openOfficesList()
        }
    }
}

// MARK: - OfficeChangingViewDelegate

extension OfficeChangingViewController: OfficeChangingViewDelegate {
    func didTapUpdateButton() {
        updateState { $0.screenState = .loading }
        interactor.getCities()
    }

    func didTapOnConfirmationButton() {
        updateState { $0.screenState = .loading }
        interactor.updateReissuesOffice()
    }
}

// MARK: - Stateful

extension OfficeChangingViewController: Stateful {
    enum ScreenState {
        case initial
        case loading
    }

    public struct State {
        var viewModels: [OfficeChangingViewModel] = []
        var screenState: ScreenState = .initial
    }

    public func displayState(_ newState: State) {
        if state.screenState != newState.screenState {
            contentView.showState(newState.screenState == .loading ? .waiting : .default)
        }
        tableManager.viewModels = newState.viewModels
        contentView.tableView.reloadData()
    }
}

// MARK: - PreferredNavigationBarStyle

extension OfficeChangingViewController: PreferredNavigationBarStyle { }
