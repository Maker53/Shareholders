import AlfaNetworking
import PromiseKit

protocol ProvidesCancelInstallmentDocuments {
    func getCancellationDraft(parameters: CancellationDraftParameters) -> Promise<Data>
}

final class CancelInstallmentDocumentsProvider: ProvidesCancelInstallmentDocuments {
    private let cancellationDraftService: CancellationDraftServiceProtocol

    init(cancellationDraftService: CancellationDraftServiceProtocol) {
        self.cancellationDraftService = cancellationDraftService
    }

    func getCancellationDraft(parameters: CancellationDraftParameters) -> Promise<Data> {
        cancellationDraftService.sendRequest(parameters: parameters)
    }
}
