import ABUIComponents
import OperationConfirmation
import ResultScreen
import SharedPromiseKit
import SharedRouter

final class CancelInstallmentBusinessLogicMock: CancelInstallmentBusinessLogic {
    // MARK: - loadData

    private(set) var loadDataWasCalled: Int = 0
    private(set) var loadDataReceivedRequest: CancelInstallment.PresentModuleData.Request?

    func loadData(_ request: CancelInstallment.PresentModuleData.Request) {
        loadDataWasCalled += 1
        loadDataReceivedRequest = request
    }

    // MARK: - loadDocument

    private(set) var loadDocumentWasCalled: Int = 0
    private(set) var loadDocumentReceivedRequest: CancelInstallment.PresentDocument.Request?

    func loadDocument(_ request: CancelInstallment.PresentDocument.Request) {
        loadDocumentWasCalled += 1
        loadDocumentReceivedRequest = request
    }

    // MARK: - cancelInstallment

    private(set) var cancelInstallmentWasCalled: Int = 0
    private(set) var cancelInstallmentReceivedRequest: CancelInstallment.Cancel.Request?

    func cancelInstallment(_ request: CancelInstallment.Cancel.Request) {
        cancelInstallmentWasCalled += 1
        cancelInstallmentReceivedRequest = request
    }
}

final class CancelInstallmentDisplayLogicMock: CancelInstallmentDisplayLogic {
    func display(_: Confirmation.OperationConfirm.ViewModel) { }

    // MARK: - displayData

    private(set) var displayDataWasCalled: Int = 0
    private(set) var displayDataReceivedViewModel: CancelInstallment.PresentModuleData.ViewModel?

    func displayData(_ viewModel: CancelInstallment.PresentModuleData.ViewModel) {
        displayDataWasCalled += 1
        displayDataReceivedViewModel = viewModel
    }

    // MARK: - displayDocument

    private(set) var displayDocumentWasCalled: Int = 0
    private(set) var displayDocumentReceivedViewModel: CancelInstallment.PresentDocument.ViewModel?

    func displayDocument(_ viewModel: CancelInstallment.PresentDocument.ViewModel) {
        displayDocumentWasCalled += 1
        displayDocumentReceivedViewModel = viewModel
    }

    // MARK: - displayDocumentError

    private(set) var displayDocumentErrorWasCalled: Int = 0
    private(set) var displayDocumentErrorReceivedData: CancelInstallment.PresentDocument.ErrorResponse?

    func displayDocumentError(_ data: CancelInstallment.PresentDocument.ErrorResponse) {
        displayDocumentErrorWasCalled += 1
        displayDocumentErrorReceivedData = data
    }

    // MARK: - displayEmptyState

    private(set) var displayEmptyStateWasCalled: Int = 0
    private(set) var displayEmptyStateReceivedViewModel: CancelInstallment.PresentEmptyState.ViewModel?

    func displayEmptyState(_ viewModel: CancelInstallment.PresentEmptyState.ViewModel) {
        displayEmptyStateWasCalled += 1
        displayEmptyStateReceivedViewModel = viewModel
    }

    // MARK: - displayResultScreen

    private(set) var displayResultScreenWasCalled: Int = 0
    private(set) var displayResultScreenReceivedViewModel: CancelInstallment.Cancel.ViewModel?

    func displayResultScreen(_ viewModel: CancelInstallment.Cancel.ViewModel) {
        displayResultScreenWasCalled += 1
        displayResultScreenReceivedViewModel = viewModel
    }
}

final class CancelInstallmentEventsMock: CancelInstallmentEvents {
    // MARK: - trackScreen

    private(set) var trackScreenWasCalled: Int = 0

    func trackScreen() {
        trackScreenWasCalled += 1
    }

    // MARK: - getConfirmationScreenName

    private(set) var getConfirmationScreenNameWasCalled: Int = 0
    var getConfirmationScreenNameStub: String!

    func getConfirmationScreenName() -> String {
        getConfirmationScreenNameWasCalled += 1
        return getConfirmationScreenNameStub
    }
}

final class CancelInstallmentPresentationLogicMock: CancelInstallmentPresentationLogic {
    var confirmationController: ConfirmationDisplayLogic?

    // MARK: - presentError

    private(set) var presentErrorWasCalled: Int = 0
    private(set) var presentErrorReceivedErrorType: CancelInstallment.ErrorType?

    func presentError(_ errorType: CancelInstallment.ErrorType) {
        presentErrorWasCalled += 1
        presentErrorReceivedErrorType = errorType
    }

    // MARK: - presentData

    private(set) var presentDataWasCalled: Int = 0
    private(set) var presentDataReceivedResponse: CancelInstallment.PresentModuleData.Response?

    func presentData(_ response: CancelInstallment.PresentModuleData.Response) {
        presentDataWasCalled += 1
        presentDataReceivedResponse = response
    }

    // MARK: - presentDocument

    private(set) var presentDocumentWasCalled: Int = 0
    private(set) var presentDocumentReceivedResponse: CancelInstallment.PresentDocument.Response?

    func presentDocument(_ response: CancelInstallment.PresentDocument.Response) {
        presentDocumentWasCalled += 1
        presentDocumentReceivedResponse = response
    }

    // MARK: - presentResultScreen

    private(set) var presentResultScreenWasCalled: Int = 0
    private(set) var presentResultScreenReceivedResponse: CancelInstallment.Cancel.Response?

    func presentResultScreen(_ response: CancelInstallment.Cancel.Response) {
        presentResultScreenWasCalled += 1
        presentResultScreenReceivedResponse = response
    }

    // MARK: - presentEmptyState

    private(set) var presentEmptyStateWasCalled: Int = 0

    func presentEmptyState() {
        presentEmptyStateWasCalled += 1
    }
}

public final class CancelInstallmentRoutesMock: CancelInstallmentRoutes {
    // MARK: - Lifecycle

    public init() { }

    // MARK: - dismiss

    public static var dismissWasCalled: Int = 0

    public static func dismiss() -> SharedRouter.Route {
        SharedRouter.Route { _ in dismissWasCalled += 1 }
    }

    // MARK: - openPDF

    public static var openPDFLocalURLWasCalled: Int = 0
    public static var openPDFLocalURLReceivedLocalURL: URL?

    public static func openPDF(localURL: URL) -> SharedRouter.Route {
        openPDFLocalURLReceivedLocalURL = localURL
        return SharedRouter.Route { _ in openPDFLocalURLWasCalled += 1 }
    }

    // MARK: - errorAlert

    public static var errorAlertWithActionHandlerWasCalled: Int = 0
    public static var errorAlertWithActionHandlerReceivedArguments: (message: String, actionHandler: (() -> Void)?)?

    public static func errorAlert(with message: String, actionHandler: (() -> Void)?) -> SharedRouter.Route {
        errorAlertWithActionHandlerReceivedArguments = (message: message, actionHandler: actionHandler)
        return SharedRouter.Route { _ in errorAlertWithActionHandlerWasCalled += 1 }
    }

    // MARK: - resultScreen

    public static var resultScreenModelWasCalled: Int = 0
    public static var resultScreenModelReceivedModel: ResultScreenModel?

    public static func resultScreen(model: ResultScreenModel) -> SharedRouter.Route {
        resultScreenModelReceivedModel = model
        return SharedRouter.Route { _ in resultScreenModelWasCalled += 1 }
    }

    // MARK: - openOperationConfirmation

    public static var openOperationConfirmationWithWasCalled: Int = 0
    public static var openOperationConfirmationWithReceivedConfiguration: OperationConfirmationPartialConfiguration?

    public static func openOperationConfirmation(with configuration: OperationConfirmationPartialConfiguration) -> SharedRouter.Route {
        openOperationConfirmationWithReceivedConfiguration = configuration
        return SharedRouter.Route { _ in openOperationConfirmationWithWasCalled += 1 }
    }

    // MARK: - instalmentsList

    public static var instalmentsListWasCalled: Int = 0

    public static func instalmentsList() -> SharedRouter.Route {
        SharedRouter.Route { _ in instalmentsListWasCalled += 1 }
    }

    // MARK: - reset

    public class func reset() {
        dismissWasCalled = 0
        openPDFLocalURLWasCalled = 0
        openPDFLocalURLReceivedLocalURL = nil
        errorAlertWithActionHandlerWasCalled = 0
        errorAlertWithActionHandlerReceivedArguments = nil
        resultScreenModelWasCalled = 0
        resultScreenModelReceivedModel = nil
        openOperationConfirmationWithWasCalled = 0
        openOperationConfirmationWithReceivedConfiguration = nil
        instalmentsListWasCalled = 0
    }
}

final class CancelInstallmentTableManagerDelegateMock: CancelInstallmentTableManagerDelegate {
    // MARK: - textFieldDidEndEditing

    private(set) var textFieldDidEndEditingWasCalled: Int = 0
    private(set) var textFieldDidEndEditingReceivedText: String?

    func textFieldDidEndEditing(_ text: String?) {
        textFieldDidEndEditingWasCalled += 1
        textFieldDidEndEditingReceivedText = text
    }

    // MARK: - didSelectDocument

    private(set) var didSelectDocumentWasCalled: Int = 0

    func didSelectDocument() {
        didSelectDocumentWasCalled += 1
    }
}

final class CancelInstallmentViewDelegateMock: CancelInstallmentViewDelegate {
    // MARK: - nextButtonAction

    private(set) var nextButtonActionWasCalled: Int = 0

    func nextButtonAction() {
        nextButtonActionWasCalled += 1
    }

    // MARK: - textFieldDidEndEditing

    private(set) var textFieldDidEndEditingWasCalled: Int = 0
    private(set) var textFieldDidEndEditingReceivedText: String?

    func textFieldDidEndEditing(_ text: String?) {
        textFieldDidEndEditingWasCalled += 1
        textFieldDidEndEditingReceivedText = text
    }

    // MARK: - selectDocument

    private(set) var selectDocumentWasCalled: Int = 0

    func selectDocument() {
        selectDocumentWasCalled += 1
    }
}

final class DisplaysCancelInstallmentViewMock: UIViewMock, DisplaysContentStateTrait, DisplaysCancelInstallmentView {
    // MARK: Добавлено руками (начало)

    // MARK: - showState

    private(set) var emptyViewReceivedModel: DefaultEmptyViewModel?
    private(set) var showStateWasCalled: Int = 0

    func showState(_ state: StyledContentState<DefaultEmptyViewRepresentable>) {
        showStateWasCalled += 1

        if case let .empty(viewModel) = state {
            emptyViewReceivedModel = viewModel as? DefaultEmptyViewModel
        }

        showDefaultState(state)
    }

    // MARK: Добавлено руками (конец)

    // MARK: - delegate

    private(set) var getDelegateWasCalled: Int = 0
    private(set) var setDelegateWasCalled: Int = 0
    var delegateStub: CancelInstallmentViewDelegate?

    var delegate: CancelInstallmentViewDelegate? {
        get {
            getDelegateWasCalled += 1
            return delegateStub
        }
        set {
            setDelegateWasCalled += 1
            delegateStub = newValue
        }
    }

    // MARK: - configure

    private(set) var configureWasCalled: Int = 0
    private(set) var configureReceivedViewModel: CancelInstallment.PresentModuleData.ViewModel?

    func configure(_ viewModel: CancelInstallment.PresentModuleData.ViewModel) {
        configureWasCalled += 1
        configureReceivedViewModel = viewModel
    }

    // MARK: - updateBottomOffset

    private(set) var updateBottomOffsetWithWillShowWasCalled: Int = 0
    private(set) var updateBottomOffsetWithWillShowReceivedArguments: (offset: CGFloat, willShow: Bool)?

    func updateBottomOffset(with offset: CGFloat, willShow: Bool) {
        updateBottomOffsetWithWillShowWasCalled += 1
        updateBottomOffsetWithWillShowReceivedArguments = (offset: offset, willShow: willShow)
    }
}

final class ManagesCancelInstallmentTableMock: UITableViewDataSourceMock, ManagesCancelInstallmentTable {
    // MARK: - sections

    var sections: [CancelInstallmentSection] = []

    // MARK: - delegate

    private(set) var getDelegateWasCalled: Int = 0
    private(set) var setDelegateWasCalled: Int = 0
    var delegateStub: CancelInstallmentTableManagerDelegate?

    var delegate: CancelInstallmentTableManagerDelegate? {
        get {
            getDelegateWasCalled += 1
            return delegateStub
        }
        set {
            setDelegateWasCalled += 1
            delegateStub = newValue
        }
    }
}

final class ProvidesCancelInstallmentDocumentsMock: ProvidesCancelInstallmentDocuments {
    // MARK: - getCancellationDraft

    private(set) var getCancellationDraftParametersWasCalled: Int = 0
    private(set) var getCancellationDraftParametersReceivedParameters: CancellationDraftParameters?
    var getCancellationDraftParametersStub: Promise<Data>!

    func getCancellationDraft(parameters: CancellationDraftParameters) -> Promise<Data> {
        getCancellationDraftParametersWasCalled += 1
        getCancellationDraftParametersReceivedParameters = parameters
        return getCancellationDraftParametersStub
    }
}

final class StoresCancelInstallmentMock: StoresCancelInstallment {
    // MARK: - installment

    private(set) var getInstallmentWasCalled: Int = 0
    private(set) var setInstallmentWasCalled: Int = 0
    var installmentStub: Instalment!

    var installment: Instalment {
        get {
            getInstallmentWasCalled += 1
            return installmentStub
        }
        set {
            setInstallmentWasCalled += 1
            installmentStub = newValue
        }
    }
}
