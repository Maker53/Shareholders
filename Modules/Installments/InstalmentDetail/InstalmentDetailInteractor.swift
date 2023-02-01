//  Created by Lyudmila Danilchenko on 25/10/2020.

import AlfaNetworking
import SharedPromiseKit

protocol InstalmentDetailBusinessLogic: AnyObject {
    func loadData()
    func openInfoDialog()
    func openTransfer()
    func openCancelInstallment()
}

final class InstalmentDetailInteractor: InstalmentDetailBusinessLogic {
    // MARK: - Properties

    let presenter: InstalmentDetailPresentationLogic
    let provider: ProvidesInstallmentDetail

    // MARK: - Lifecycle

    init(
        presenter: InstalmentDetailPresentationLogic,
        provider: ProvidesInstallmentDetail
    ) {
        self.presenter = presenter
        self.provider = provider
    }

    // MARK: - InstalmentDetailBusinessLogic

    func loadData() {
        let context = provider.getInstallmentDetailContext()
        switch context {
        case let .full(fullModel):
            presenter.presentData(fullModel)
        case let .plain(plainModel):
            fetchInstallmentDetail(plainModel)
        }
    }

    func openInfoDialog() {
        presenter.presentInfoDialog()
    }

    func openTransfer() {
        presenter.presentTransfer()
    }

    func openCancelInstallment() {
        guard case let .full(model) = provider.getInstallmentDetailContext() else { return }

        let context = CancelInstallmentContext(installment: model.installment)
        presenter.presentCancelInstallment(.init(cancelInstallmentContext: context))
    }
}

private extension InstalmentDetailInteractor {
    func fetchInstallmentDetail(_ plainModel: InstallmentDetailsContext.PlainModel) {
        firstly {
            provider.getInstallment(model: plainModel)
        }.done { [weak self] _ in
            guard case let .full(model) = self?.provider.getInstallmentDetailContext()
            else {
                self?.presentError("Can't find installment with id: \(plainModel.uid)")
                return
            }

            self?.presenter.presentData(model)
        }.catch { [weak self] in
            self?.presentError($0.localizedDescription)
        }
    }

    func presentError(_ log: String) {
        presenter.presentError(.loadingFailed(Resources.L10n.APIClientError.somethingWentWrong))
        ABLogError(log)
    }
}
