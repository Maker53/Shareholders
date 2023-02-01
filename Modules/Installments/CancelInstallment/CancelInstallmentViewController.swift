//  Created by Рамазанов Виталий Глебович on 27/08/2021.

import ABUIComponents
import OperationConfirmation
import ResultScreen
import SharedProtocolsAndModels
import SharedRouter
import SnapKit

protocol CancelInstallmentDisplayLogic: ConfirmationDisplayLogic {
    func displayData(_ viewModel: CancelInstallment.PresentModuleData.ViewModel)
    func displayDocument(_ viewModel: CancelInstallment.PresentDocument.ViewModel)
    func displayDocumentError(_ data: CancelInstallment.PresentDocument.ErrorResponse)
    func displayEmptyState(_ viewModel: CancelInstallment.PresentEmptyState.ViewModel)
    func displayResultScreen(_ viewModel: CancelInstallment.Cancel.ViewModel)
}

public final class CancelInstallmentViewController<Routes: CancelInstallmentRoutes>: UIViewController, Navigates {
    enum State: Equatable {
        case loading
        case displayData(CancelInstallment.PresentModuleData.ViewModel)
    }

    // MARK: - Views

    lazy var contentView: DisplaysCancelInstallmentView = CancelInstallmentView()

    // MARK: - Properties

    var state: State = .loading
    lazy var keyboardTracker: KeyboardObservable = KeyboardTracker(delegate: self, viewController: self)

    let interactor: CancelInstallmentBusinessLogic
    private let analytics: CancelInstallmentEvents

    // MARK: - Lifecycle

    required init(
        analytics: CancelInstallmentEvents,
        interactor: CancelInstallmentBusinessLogic
    ) {
        self.analytics = analytics
        self.interactor = interactor

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override public func loadView() {
        view = contentView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = [.bottom]

        analytics.trackScreen()
        configureNavigationBar()
        contentView.delegate = self
        contentView.showState(.waiting)
        interactor.loadData(nil)
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardTracker.startTracking()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardTracker.stopTracking()
    }

    @objc
    func didTapBackButton() {
        navigate(to: Routes.dismiss())
    }

    func displayResultScreen(_ viewModel: CancelInstallment.Cancel.ViewModel) {
        var modelWithAction = viewModel.model
        modelWithAction.onDoneButtonTapped = { [weak self] in self?.resultScreenDismissed() }
        modelWithAction.onCloseButtonTapped = { [weak self] in self?.resultScreenDismissed() }
        navigate(to: Routes.resultScreen(model: modelWithAction))
    }

    private func resultScreenDismissed() {
        navigate(to: Routes.instalmentsList())
    }
}

// MARK: - CancelInstallmentDisplayLogic

extension CancelInstallmentViewController: CancelInstallmentDisplayLogic {
    func displayData(_ viewModel: CancelInstallment.PresentModuleData.ViewModel) {
        state = .displayData(viewModel)
        contentView.showState(.default)
        contentView.configure(viewModel)
    }

    func displayDocument(_ viewModel: CancelInstallment.PresentDocument.ViewModel) {
        contentView.showState(.default)
        navigate(to: Routes.openPDF(localURL: viewModel.url))
    }

    func displayDocumentError(_ data: CancelInstallment.PresentDocument.ErrorResponse) {
        contentView.showState(.default)
        navigate(to: Routes.errorAlert(with: data, actionHandler: nil))
    }

    func displayEmptyState(_ viewModel: CancelInstallment.PresentEmptyState.ViewModel) {
        let request: CancelInstallment.PresentModuleData.Request
        if case let .displayData(viewModel) = state {
            request = viewModel.parameters
        } else {
            request = nil
        }

        var viewModel = viewModel
        viewModel.firstButtonViewModel?.buttonHandler = { [weak self] _ in
            self?.interactor.loadData(request)
        }
        contentView.showState(.empty(viewModel))
    }

    // MARK: ConfirmationDisplayLogic

    public func display(_ viewModel: Confirmation.OperationConfirm.ViewModel) {
        switch viewModel.state {
        case .startLoading:
            contentView.showState(.waiting)

        case .endLoading:
            contentView.showState(.default)

        case let .error(message):
            navigate(to: Routes.errorAlert(with: message, actionHandler: nil))

        case let .showConfirmation(configuration):
            let config = (
                delegate: configuration.delegate,
                provider: configuration.provider,
                interactorConfiguration: configuration.interactorConfiguration,
                screenName: analytics.getConfirmationScreenName()
            )
            contentView.showState(.default)
            navigate(to: Routes.openOperationConfirmation(with: config))
        }
    }
}

// MARK: - CancelInstallmentViewDelegate

extension CancelInstallmentViewController: CancelInstallmentViewDelegate {
    func nextButtonAction() {
        guard case let .displayData(viewModel) = state,
              viewModel.parameters.inputError == nil
        else {
            return
        }
        interactor.cancelInstallment(.init(parameters: viewModel.parameters))
    }

    func textFieldDidEndEditing(_ text: String?) {
        guard case let .displayData(viewModel) = state else { return }
        interactor.loadData(
            .init(
                email: text,
                inputError: viewModel.parameters.inputError,
                agreementNumber: viewModel.parameters.agreementNumber,
                installmentNumber: viewModel.parameters.installmentNumber
            )
        )
    }

    func selectDocument() {
        guard case let .displayData(viewModel) = state else { return }
        contentView.showState(.waiting)
        interactor.loadDocument(.init(parameters: viewModel.parameters))
    }
}

// MARK: - KeyboardTrackerDelegate

extension CancelInstallmentViewController: KeyboardTrackerDelegate {
    public func keyboardWillShow(_ configurations: KeyboardTracker.KeyboardConfigurations) {
        contentView.updateBottomOffset(with: configurations.contentBottomOffset, willShow: true)
    }

    public func keyboardWillHide(_ configurations: KeyboardTracker.KeyboardConfigurations) {
        contentView.updateBottomOffset(with: configurations.contentBottomOffset, willShow: false)
    }
}

// MARK: - PreferredNavigationBarStyle

extension CancelInstallmentViewController: PreferredNavigationBarStyle { }

// MARK: - Private

private extension CancelInstallmentViewController {
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            target: self,
            action: #selector(didTapBackButton)
        )
    }
}
