import ABUIComponents
import SharedPromiseKit
import SharedRouter

final class DisplaysInstalmentListViewMock: DisplaysContentStateTraitMock<EmptyViewStyle.FullPage.Primary>, DisplaysInstalmentListView {
    // MARK: - stateView

    private(set) var getStateViewWasCalled: Int = 0
    private(set) var setStateViewWasCalled: Int = 0
    var stateViewStub: DisplaysDefaultContentState!

    var stateView: DisplaysDefaultContentState {
        get {
            getStateViewWasCalled += 1
            return stateViewStub
        }
        set {
            setStateViewWasCalled += 1
            stateViewStub = newValue
        }
    }

    // MARK: - reloadTableView

    private(set) var reloadTableViewWasCalled: Int = 0

    func reloadTableView() {
        reloadTableViewWasCalled += 1
    }

    // MARK: - endRefreshing

    private(set) var endRefreshingWasCalled: Int = 0

    func endRefreshing() {
        endRefreshingWasCalled += 1
    }
}

final class InstalmentListBusinessLogicMock: InstalmentListBusinessLogic {
    // MARK: - openNewInstalment

    private(set) var openNewInstalmentWasCalled: Int = 0

    func openNewInstalment() {
        openNewInstalmentWasCalled += 1
    }

    // MARK: - loadData

    private(set) var loadDataWasCalled: Int = 0
    private(set) var loadDataReceivedRequest: InstalmentList.PresentModuleData.Request?

    func loadData(_ request: InstalmentList.PresentModuleData.Request) {
        loadDataWasCalled += 1
        loadDataReceivedRequest = request
    }

    // MARK: - openInstallmentDetails

    private(set) var openInstallmentDetailsWasCalled: Int = 0
    private(set) var openInstallmentDetailsReceivedRequest: InstalmentList.PresentInstallmentDetails.Request?

    func openInstallmentDetails(_ request: InstalmentList.PresentInstallmentDetails.Request) {
        openInstallmentDetailsWasCalled += 1
        openInstallmentDetailsReceivedRequest = request
    }
}

final class InstalmentListDisplayLogicMock: InstalmentListDisplayLogic {
    // MARK: - displayInstalments

    private(set) var displayInstalmentsWasCalled: Int = 0
    private(set) var displayInstalmentsReceivedViewModel: InstalmentList.PresentModuleData.ViewModel?

    func displayInstalments(_ viewModel: InstalmentList.PresentModuleData.ViewModel) {
        displayInstalmentsWasCalled += 1
        displayInstalmentsReceivedViewModel = viewModel
    }

    // MARK: - displayError

    private(set) var displayErrorWasCalled: Int = 0
    private(set) var displayErrorReceivedViewModel: InstalmentList.LoadingError.ViewModel?

    func displayError(_ viewModel: InstalmentList.LoadingError.ViewModel) {
        displayErrorWasCalled += 1
        displayErrorReceivedViewModel = viewModel
    }

    // MARK: - displayPlusButton

    private(set) var displayPlusButtonWasCalled: Int = 0
    private(set) var displayPlusButtonReceivedViewModel: InstalmentList.PresentPlusButton.ViewModel?

    func displayPlusButton(_ viewModel: InstalmentList.PresentPlusButton.ViewModel) {
        displayPlusButtonWasCalled += 1
        displayPlusButtonReceivedViewModel = viewModel
    }

    // MARK: - displayEmptyView

    private(set) var displayEmptyViewWasCalled: Int = 0
    private(set) var displayEmptyViewReceivedViewModel: InstalmentList.PresentEmptyState.ViewModel?

    func displayEmptyView(_ viewModel: InstalmentList.PresentEmptyState.ViewModel) {
        displayEmptyViewWasCalled += 1
        displayEmptyViewReceivedViewModel = viewModel
    }

    // MARK: - displayNewInstalment

    private(set) var displayNewInstalmentWasCalled: Int = 0
    private(set) var displayNewInstalmentReceivedViewModel: InstalmentList.PresentNewInstalmentData.ViewModel?

    func displayNewInstalment(_ viewModel: InstalmentList.PresentNewInstalmentData.ViewModel) {
        displayNewInstalmentWasCalled += 1
        displayNewInstalmentReceivedViewModel = viewModel
    }

    // MARK: - displayNewInstallmentSelection

    private(set) var displayNewInstallmentSelectionWasCalled: Int = 0
    private(set) var displayNewInstallmentSelectionReceivedViewModel: InstalmentList.PresentNewInstalmentSelection.ViewModel?

    func displayNewInstallmentSelection(_ viewModel: InstalmentList.PresentNewInstalmentSelection.ViewModel) {
        displayNewInstallmentSelectionWasCalled += 1
        displayNewInstallmentSelectionReceivedViewModel = viewModel
    }

    // MARK: - displayInstallmentDetails

    private(set) var displayInstallmentDetailsWasCalled: Int = 0
    private(set) var displayInstallmentDetailsReceivedViewModel: InstalmentList.PresentInstallmentDetails.ViewModel?

    func displayInstallmentDetails(_ viewModel: InstalmentList.PresentInstallmentDetails.ViewModel) {
        displayInstallmentDetailsWasCalled += 1
        displayInstallmentDetailsReceivedViewModel = viewModel
    }

    // MARK: - dismiss

    private(set) var dismissWasCalled: Int = 0

    func dismiss() {
        dismissWasCalled += 1
    }
}

final class InstalmentListEventsMock: InstalmentListEvents {
    // MARK: - trackScreen

    private(set) var trackScreenWasCalled: Int = 0

    func trackScreen() {
        trackScreenWasCalled += 1
    }

    // MARK: - trackError

    private(set) var trackErrorWasCalled: Int = 0
    private(set) var trackErrorReceivedText: String?

    func trackError(_ text: String) {
        trackErrorWasCalled += 1
        trackErrorReceivedText = text
    }
}

final class InstalmentListPresentationLogicMock: InstalmentListPresentationLogic {
    // MARK: - presentError

    private(set) var presentErrorWasCalled: Int = 0
    private(set) var presentErrorReceivedResponse: InstalmentList.LoadingError.Response?

    func presentError(_ response: InstalmentList.LoadingError.Response) {
        presentErrorWasCalled += 1
        presentErrorReceivedResponse = response
    }

    // MARK: - presentInstalmentList

    private(set) var presentInstalmentListWasCalled: Int = 0
    private(set) var presentInstalmentListReceivedResponse: InstalmentList.PresentModuleData.Response?

    func presentInstalmentList(_ response: InstalmentList.PresentModuleData.Response) {
        presentInstalmentListWasCalled += 1
        presentInstalmentListReceivedResponse = response
    }

    // MARK: - presentPlusButton

    private(set) var presentPlusButtonWasCalled: Int = 0
    private(set) var presentPlusButtonReceivedResponse: InstalmentList.PresentPlusButton.Reponse?

    func presentPlusButton(_ response: InstalmentList.PresentPlusButton.Reponse) {
        presentPlusButtonWasCalled += 1
        presentPlusButtonReceivedResponse = response
    }

    // MARK: - presentNewInstalment

    private(set) var presentNewInstalmentWasCalled: Int = 0
    private(set) var presentNewInstalmentReceivedResponse: InstalmentList.PresentNewInstalmentData.Response?

    func presentNewInstalment(_ response: InstalmentList.PresentNewInstalmentData.Response) {
        presentNewInstalmentWasCalled += 1
        presentNewInstalmentReceivedResponse = response
    }

    // MARK: - presentEmptyState

    private(set) var presentEmptyStateWasCalled: Int = 0
    private(set) var presentEmptyStateReceivedResponse: InstalmentList.PresentEmptyState.Response?

    func presentEmptyState(_ response: InstalmentList.PresentEmptyState.Response) {
        presentEmptyStateWasCalled += 1
        presentEmptyStateReceivedResponse = response
    }

    // MARK: - presentInstallmentDetails

    private(set) var presentInstallmentDetailsWasCalled: Int = 0
    private(set) var presentInstallmentDetailsReceivedResponse: InstalmentList.PresentInstallmentDetails.Response?

    func presentInstallmentDetails(_ response: InstalmentList.PresentInstallmentDetails.Response) {
        presentInstallmentDetailsWasCalled += 1
        presentInstallmentDetailsReceivedResponse = response
    }
}

public final class InstalmentListRoutesMock: InstalmentListRoutes {
    // MARK: - Lifecycle

    public init() { }

    // MARK: - back

    public static var backWasCalled: Int = 0

    public static func back() -> SharedRouter.Route {
        SharedRouter.Route { _ in backWasCalled += 1 }
    }

    // MARK: - dismiss

    public static var dismissWasCalled: Int = 0

    public static func dismiss() -> SharedRouter.Route {
        SharedRouter.Route { _ in dismissWasCalled += 1 }
    }

    // MARK: - instalmentDetails

    public static var instalmentDetailsWithWasCalled: Int = 0
    public static var instalmentDetailsWithReceivedContext: InstallmentDetailsContext?

    public static func instalmentDetails(with context: InstallmentDetailsContext) -> SharedRouter.Route {
        instalmentDetailsWithReceivedContext = context
        return SharedRouter.Route { _ in instalmentDetailsWithWasCalled += 1 }
    }

    // MARK: - alert

    public static var alertTextActionsStyleWasCalled: Int = 0
    public static var alertTextActionsStyleReceivedArguments: (text: UIAlertText, actions: [UIAlertAction]?, style: UIAlertRouteStyle)?

    public static func alert(text: UIAlertText, actions: [UIAlertAction]?, style: UIAlertRouteStyle) -> SharedRouter.Route {
        alertTextActionsStyleReceivedArguments = (text: text, actions: actions, style: style)
        return SharedRouter.Route { _ in alertTextActionsStyleWasCalled += 1 }
    }

    // MARK: - reset

    public class func reset() {
        backWasCalled = 0
        dismissWasCalled = 0
        instalmentDetailsWithWasCalled = 0
        instalmentDetailsWithReceivedContext = nil
        alertTextActionsStyleWasCalled = 0
        alertTextActionsStyleReceivedArguments = nil
    }
}

final class InstalmentListTableManagerDelegateMock: InstalmentListTableManagerDelegate {
    // MARK: - didSelectInstalment

    private(set) var didSelectInstalmentTypeWasCalled: Int = 0
    private(set) var didSelectInstalmentTypeReceivedArguments: (instalment: Instalment, type: InstallmentType)?

    func didSelectInstalment(_ instalment: Instalment, type: InstallmentType) {
        didSelectInstalmentTypeWasCalled += 1
        didSelectInstalmentTypeReceivedArguments = (instalment: instalment, type: type)
    }
}

final class InstalmentListViewDelegateMock: InstalmentListViewDelegate {
    // MARK: - pullToRefreshAction

    private(set) var pullToRefreshActionWasCalled: Int = 0

    func pullToRefreshAction() {
        pullToRefreshActionWasCalled += 1
    }
}

final class ManagesInstalmentListTableMock: UITableViewDataSourceMock, ManagesInstalmentListTable {
    // MARK: - sections

    var sections: [InstallmentListSection] = []

    // MARK: - delegate

    private(set) var getDelegateWasCalled: Int = 0
    private(set) var setDelegateWasCalled: Int = 0
    var delegateStub: InstalmentListTableManagerDelegate?

    var delegate: InstalmentListTableManagerDelegate? {
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

final class ProvidesInstalmentListMock: ProvidesInstalmentList {
    // MARK: - getInstalments

    // Начало куска, допиленного руками
    private(set) var getInstalmentsUsingCacheWasCalled: Int = 0
    private(set) var getInstalmentsUsingCacheReceivedUsingCache: Bool?
    private(set) var getInstalmentsUsingCacheReceivedInstallmentType: [InstallmentType] = []
    var getInstalmentsUsingCacheCreditStub: Promise<[Instalment]>!
    var getInstalmentsUsingCacheDebitStub: Promise<[Instalment]>!

    func getInstalments(installmentType: InstallmentType, usingCache: Bool) -> Promise<[Instalment]> {
        getInstalmentsUsingCacheReceivedInstallmentType.append(installmentType)
        getInstalmentsUsingCacheWasCalled += 1
        getInstalmentsUsingCacheReceivedUsingCache = usingCache

        switch installmentType {
        case .credit:
            return getInstalmentsUsingCacheCreditStub
        case .debit, .promotional:
            return getInstalmentsUsingCacheDebitStub
        }
    }

    // MARK: - getInstalmentOffers

    private(set) var getInstalmentOffersWasCalled: Int = 0
    private(set) var getInstalmentOffersContextReceivedContext: [InstallmentOfferContext] = []
    var getInstalmentOffersCreditStub: Promise<InstalmentOfferResponse>!
    var getInstalmentOffersDebitStub: Promise<InstalmentOfferResponse>!

    func getInstalmentOffers(context: InstallmentOfferContext) -> Promise<InstalmentOfferResponse> {
        getInstalmentOffersWasCalled += 1
        getInstalmentOffersContextReceivedContext.append(context)
        switch context.installmentType {
        case .credit:
            return getInstalmentOffersCreditStub
        case .debit, .promotional:
            return getInstalmentOffersDebitStub
        }
    }

    // Конец куска, допиленного руками
}

final class StoresInstalmentListMock: StoresInstalmentList {
    // MARK: - instalmentListModelWithType

    private(set) var getInstalmentListModelWithTypeWasCalled: Int = 0
    private(set) var setInstalmentListModelWithTypeWasCalled: Int = 0
    var instalmentListModelWithTypeStub: [InstallmentType: InstalmentListResponse?]!
    var instalmentListModelWithType: [InstallmentType: InstalmentListResponse?] {
        get {
            getInstalmentListModelWithTypeWasCalled += 1
            return instalmentListModelWithTypeStub
        }
        set {
            setInstalmentListModelWithTypeWasCalled += 1
            instalmentListModelWithTypeStub = newValue
        }
    }

    // MARK: - instalmentOffersModelWithType

    private(set) var getInstalmentListOffersModelWithTypeWasCalled: Int = 0
    private(set) var setInstalmentListOffersModelWithTypeWasCalled: Int = 0
    var instalmentOffersModelWithTypeStub: [InstallmentType: InstalmentOfferResponse?]!
    var instalmentOffersModelWithType: [InstallmentType: InstalmentOfferResponse?] {
        get {
            getInstalmentListOffersModelWithTypeWasCalled += 1
            return instalmentOffersModelWithTypeStub
        }
        set {
            setInstalmentListOffersModelWithTypeWasCalled += 1
            instalmentOffersModelWithTypeStub = newValue
        }
    }
}
