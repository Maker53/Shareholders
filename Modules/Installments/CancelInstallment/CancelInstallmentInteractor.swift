//  Created by Рамазанов Виталий Глебович on 27/08/2021.

import AlfaFoundation
import AlfaNetworking
import OperationConfirmation
import PromiseKit

protocol CancelInstallmentBusinessLogic: AnyObject {
    func loadData(_ request: CancelInstallment.PresentModuleData.Request)
    func loadDocument(_ request: CancelInstallment.PresentDocument.Request)
    func cancelInstallment(_ request: CancelInstallment.Cancel.Request)
}

final class CancelInstallmentInteractor: CancelInstallmentBusinessLogic {
    typealias ProviderForConfirmation = ParametrizedConfirmationProvider<CancelInstallmentConfirmationModel>

    // MARK: - Properties

    private let presenter: CancelInstallmentPresentationLogic
    private let documentsProvider: ProvidesCancelInstallmentDocuments
    private let dataStore: StoresCancelInstallment

    // MARK: - Confirmation Flow

    let confirmationProvider: ProviderForConfirmation
    var confirmationValidatePassword: ValidatePasswordResponse?
    var confirmationReference: OperationConfirmationModel?
    var confirmationPresenter: ConfirmationPresentationLogic {
        presenter
    }

    // MARK: - Lifecycle

    init(
        presenter: CancelInstallmentPresentationLogic,
        documentsProvider: ProvidesCancelInstallmentDocuments,
        confirmationProvider: ProviderForConfirmation,
        dataStore: StoresCancelInstallment
    ) {
        self.presenter = presenter
        self.documentsProvider = documentsProvider
        self.confirmationProvider = confirmationProvider
        self.dataStore = dataStore
    }

    // MARK: - CancelInstallmentBusinessLogic

    func loadData(_ request: CancelInstallment.PresentModuleData.Request) {
        let installment = dataStore.installment
        presenter.presentData(
            .init(
                installment: installment,
                parameters: .init(
                    email: request?.email,
                    inputError: inputError(from: request?.email),
                    agreementNumber: installment.agreementNumber,
                    installmentNumber: installment.uid
                )
            )
        )
    }

    func loadDocument(_ request: CancelInstallment.PresentDocument.Request) {
        firstly {
            documentsProvider.getCancellationDraft(
                parameters: .init(
                    agreementNumber: request.parameters.agreementNumber,
                    installmentNumber: request.parameters.installmentNumber
                )
            )
        }.done { [weak self] data in
            guard let self = self else { return }
            self.saveAndOpenDocument(data, withName: L10n.CancelInstallment.cancelDocumentTitle)
        }.catch { [weak self] in
            self?.presenter.presentError(.documentLoadingError($0.localizedDescription))
        }
    }

    func cancelInstallment(_ request: CancelInstallment.Cancel.Request) {
        guard
            let email = request.parameters.email,
            email.isNotEmpty
        else {
            ABLogError("There is no email to cancel installment")
            return
        }
        performToConfirmation(with: .init(email: email))
    }
}

// MARK: - ConfirmationBusinessLogic

extension CancelInstallmentInteractor: ConfirmationBusinessLogic {
    typealias Parameters = CancelInstallmentConfirmationModel

    func didCompleteConfirmation() {
        guard confirmationValidatePassword != nil
        else {
            presenter.presentEmptyState()
            return
        }
        presenter.presentResultScreen(.init(isSuccess: true))
    }
}

private extension CancelInstallmentInteractor {
    func inputError(from input: String?) -> CancelInstallment.InputError? {
        guard let input = input else { return .empty }
        guard input.looksLikeEmail() else { return .incorrect }

        return nil
    }

    func saveAndOpenDocument(_ data: Data, withName name: String) {
        let destinationURL = URL(fileURLWithPath: NSTemporaryDirectory() + "\(name).pdf")
        try? data.write(to: destinationURL)
        presenter.presentDocument(.init(url: destinationURL))
    }
}
