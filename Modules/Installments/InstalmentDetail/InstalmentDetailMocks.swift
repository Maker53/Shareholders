import ABUIComponents
import SharedPromiseKit
import SharedRouter

final class DisplaysInstalmentDetailViewMock: ContentStateViewMock, DisplaysInstalmentDetailView {
    // MARK: - configure

    private(set) var configureWasCalled: Int = 0
    private(set) var configureReceivedViewModel: InstalmentDetail.PresentModuleData.ViewModel?

    func configure(_ viewModel: InstalmentDetail.PresentModuleData.ViewModel) {
        configureWasCalled += 1
        configureReceivedViewModel = viewModel
    }

    // MARK: - reloadTableView

    private(set) var reloadTableViewWasCalled: Int = 0

    func reloadTableView() {
        reloadTableViewWasCalled += 1
    }

    // MARK: - setupHeader

    private(set) var setupHeaderWasCalled: Int = 0

    func setupHeader(_: String) {
        setupHeaderWasCalled += 1
    }
}

final class DisplaysInstalmentDetailViewDelegateMock: DisplaysInstalmentDetailViewDelegate {
    // MARK: - repaymentButtonClicked

    private(set) var repaymentButtonClickedWasCalled: Int = 0

    func repaymentButtonClicked() {
        repaymentButtonClickedWasCalled += 1
    }
}

final class InstallmentDetailPresenterWorkerMock: InstallmentDetailPresenterWorkerProtocol {
    // MARK: - makeDataSections

    private(set) var makeDataSectionsInstallmentInstallmentTypeWasCalled: Int = 0
    private(set) var makeDataSectionsInstallmentInstallmentTypeReceivedArguments: (installment: Instalment, installmentType: InstallmentType)?
    var makeDataSectionsInstallmentInstallmentTypeStub: [Section]!

    func makeDataSections(installment: Instalment, installmentType: InstallmentType) -> [Section] {
        makeDataSectionsInstallmentInstallmentTypeWasCalled += 1
        makeDataSectionsInstallmentInstallmentTypeReceivedArguments = (installment: installment, installmentType: installmentType)
        return makeDataSectionsInstallmentInstallmentTypeStub
    }

    // MARK: - makeEarlyRepaymentSections

    private(set) var makeEarlyRepaymentSectionsInstallmentInstallmentTypeIsFeatureAvailableWasCalled: Int = 0
    private(set) var makeEarlyRepaymentSectionsInstallmentInstallmentTypeIsFeatureAvailableReceivedArguments: (installment: Instalment, installmentType: InstallmentType, isFeatureAvailable: Bool)?
    var makeEarlyRepaymentSectionsInstallmentInstallmentTypeIsFeatureAvailableStub: [Section]!

    func makeEarlyRepaymentSections(installment: Instalment, installmentType: InstallmentType, isFeatureAvailable: Bool) -> [Section] {
        makeEarlyRepaymentSectionsInstallmentInstallmentTypeIsFeatureAvailableWasCalled += 1
        makeEarlyRepaymentSectionsInstallmentInstallmentTypeIsFeatureAvailableReceivedArguments = (installment: installment, installmentType: installmentType, isFeatureAvailable: isFeatureAvailable)
        return makeEarlyRepaymentSectionsInstallmentInstallmentTypeIsFeatureAvailableStub
    }
}

final class InstalmentDetailBusinessLogicMock: InstalmentDetailBusinessLogic {
    // MARK: - loadData

    private(set) var loadDataWasCalled: Int = 0

    func loadData() {
        loadDataWasCalled += 1
    }

    // MARK: - openInfoDialog

    private(set) var openInfoDialogWasCalled: Int = 0

    func openInfoDialog() {
        openInfoDialogWasCalled += 1
    }

    // MARK: - openTransfer

    private(set) var openTransferWasCalled: Int = 0

    func openTransfer() {
        openTransferWasCalled += 1
    }

    // MARK: - openCancelInstallment

    private(set) var openCancelInstallmentWasCalled: Int = 0

    func openCancelInstallment() {
        openCancelInstallmentWasCalled += 1
    }
}

final class InstalmentDetailDisplayLogicMock: InstalmentDetailDisplayLogic {
    // MARK: - displayData

    private(set) var displayDataWasCalled: Int = 0
    private(set) var displayDataReceivedViewModel: InstalmentDetail.PresentModuleData.ViewModel?

    func displayData(_ viewModel: InstalmentDetail.PresentModuleData.ViewModel) {
        displayDataWasCalled += 1
        displayDataReceivedViewModel = viewModel
    }

    // MARK: - displayTransfer

    private(set) var displayTransferWasCalled: Int = 0

    func displayTransfer() {
        displayTransferWasCalled += 1
    }

    // MARK: - infoDialogAction

    private(set) var infoDialogActionWasCalled: Int = 0

    func infoDialogAction() {
        infoDialogActionWasCalled += 1
    }

    // MARK: - debitRepaymentAction

    private(set) var debitRepaymentActionWasCalled: Int = 0

    func debitRepaymentAction() {
        debitRepaymentActionWasCalled += 1
    }

    // MARK: - displayCancelInstalment

    private(set) var displayCancelInstalmentWasCalled: Int = 0
    private(set) var displayCancelInstalmentReceivedViewModel: InstalmentDetail.PresentCancelInstalment.ViewModel?

    func displayCancelInstalment(_ viewModel: InstalmentDetail.PresentCancelInstalment.ViewModel) {
        displayCancelInstalmentWasCalled += 1
        displayCancelInstalmentReceivedViewModel = viewModel
    }
}

final class InstalmentDetailEventsMock: InstalmentDetailEvents {
    // MARK: - trackScreen

    private(set) var trackScreenWasCalled: Int = 0

    func trackScreen() {
        trackScreenWasCalled += 1
    }

    // MARK: - trackButtonTap

    private(set) var trackButtonTapWasCalled: Int = 0

    func trackButtonTap() {
        trackButtonTapWasCalled += 1
    }
}

final class InstalmentDetailPresentationLogicMock: InstalmentDetailPresentationLogic {
    // MARK: - presentError

    private(set) var presentErrorWasCalled: Int = 0
    private(set) var presentErrorReceivedErrorType: InstalmentDetail.ErrorType?

    func presentError(_ errorType: InstalmentDetail.ErrorType) {
        presentErrorWasCalled += 1
        presentErrorReceivedErrorType = errorType
    }

    // MARK: - presentData

    private(set) var presentDataWasCalled: Int = 0
    private(set) var presentDataReceivedResponse: InstalmentDetail.PresentModuleData.Response?

    func presentData(_ response: InstalmentDetail.PresentModuleData.Response) {
        presentDataWasCalled += 1
        presentDataReceivedResponse = response
    }

    // MARK: - presentDebitRepayment

    private(set) var presentDebitRepaymentWasCalled: Int = 0

    func presentDebitRepayment() {
        presentDebitRepaymentWasCalled += 1
    }

    // MARK: - presentDebitDialog

    private(set) var presentDebitDialogWasCalled: Int = 0
    private(set) var presentDebitDialogReceivedResponse: InstalmentDetail.PresentDebitDialog.Response?

    func presentDebitDialog(_ response: InstalmentDetail.PresentDebitDialog.Response) {
        presentDebitDialogWasCalled += 1
        presentDebitDialogReceivedResponse = response
    }

    // MARK: - presentInfoDialog

    private(set) var presentInfoDialogWasCalled: Int = 0

    func presentInfoDialog() {
        presentInfoDialogWasCalled += 1
    }

    // MARK: - presentTransfer

    private(set) var presentTransferWasCalled: Int = 0

    func presentTransfer() {
        presentTransferWasCalled += 1
    }

    // MARK: - presentCancelInstallment

    private(set) var presentCancelInstallmentWasCalled: Int = 0
    private(set) var presentCancelInstallmentReceivedResponse: InstalmentDetail.PresentCancelInstalment.Response?

    func presentCancelInstallment(_ response: InstalmentDetail.PresentCancelInstalment.Response) {
        presentCancelInstallmentWasCalled += 1
        presentCancelInstallmentReceivedResponse = response
    }
}

public final class InstalmentDetailRoutesMock: InstalmentDetailRoutes {
    // MARK: - Lifecycle

    public init() { }

    // MARK: - back

    public static var backWasCalled: Int = 0

    public static func back() -> SharedRouter.Route {
        SharedRouter.Route { _ in backWasCalled += 1 }
    }

    // MARK: - transfer

    public static var transferSourceDestinationWasCalled: Int = 0
    public static var transferSourceDestinationReceivedArguments: (source: String?, destination: String?)?

    public static func transfer(source: String?, destination: String?) -> SharedRouter.Route {
        transferSourceDestinationReceivedArguments = (source: source, destination: destination)
        return SharedRouter.Route { _ in transferSourceDestinationWasCalled += 1 }
    }

    // MARK: - cancelInstallment

    public static var cancelInstallmentWithWasCalled: Int = 0
    public static var cancelInstallmentWithReceivedContext: CancelInstallmentContext?

    public static func cancelInstallment(with context: CancelInstallmentContext) -> SharedRouter.Route {
        cancelInstallmentWithReceivedContext = context
        return SharedRouter.Route { _ in cancelInstallmentWithWasCalled += 1 }
    }

    // MARK: - reset

    public class func reset() {
        backWasCalled = 0
        transferSourceDestinationWasCalled = 0
        transferSourceDestinationReceivedArguments = nil
        cancelInstallmentWithWasCalled = 0
        cancelInstallmentWithReceivedContext = nil
    }
}

final class InstalmentDetailTableManagerDelegateMock: InstalmentDetailTableManagerDelegate {
    // MARK: - didTapRepaymentInfo

    private(set) var didTapRepaymentInfoWasCalled: Int = 0

    func didTapRepaymentInfo() {
        didTapRepaymentInfoWasCalled += 1
    }

    // MARK: - didTapCancelBanner

    private(set) var didTapCancelBannerWasCalled: Int = 0

    func didTapCancelBanner() {
        didTapCancelBannerWasCalled += 1
    }
}

final class ManagesInstalmentDetailTableMock: UITableViewDataSourceMock, ManagesInstalmentDetailTable {
    // MARK: - delegate

    private(set) var getDelegateWasCalled: Int = 0
    private(set) var setDelegateWasCalled: Int = 0
    var delegateStub: InstalmentDetailTableManagerDelegate?

    var delegate: InstalmentDetailTableManagerDelegate? {
        get {
            getDelegateWasCalled += 1
            return delegateStub
        }
        set {
            setDelegateWasCalled += 1
            delegateStub = newValue
        }
    }

    // MARK: - sections

    var sections: [DetailInfoSection] = []
}

final class ProvidesInstallmentDetailMock: ProvidesInstallmentDetail {
    // MARK: - getInstallment

    private(set) var getInstallmentModelWasCalled: Int = 0
    private(set) var getInstallmentModelReceivedModel: InstallmentDetailsContext.PlainModel?
    var getInstallmentModelStub: Promise<[Instalment]>!

    func getInstallment(model: InstallmentDetailsContext.PlainModel) -> Promise<[Instalment]> {
        getInstallmentModelWasCalled += 1
        getInstallmentModelReceivedModel = model
        return getInstallmentModelStub
    }

    // MARK: - getInstallmentDetailContext

    private(set) var getInstallmentDetailContextWasCalled: Int = 0
    var getInstallmentDetailContextStub: InstallmentDetailsContext!

    func getInstallmentDetailContext() -> InstallmentDetailsContext {
        getInstallmentDetailContextWasCalled += 1
        return getInstallmentDetailContextStub
    }
}

final class StoresInstallmentDetailContextMock: StoresInstallmentDetailContext {
    // MARK: - context

    private(set) var getContextWasCalled: Int = 0
    private(set) var setContextWasCalled: Int = 0
    var contextStub: InstallmentDetailsContext!

    var context: InstallmentDetailsContext {
        get {
            getContextWasCalled += 1
            return contextStub
        }
        set {
            setContextWasCalled += 1
            contextStub = newValue
        }
    }
}
