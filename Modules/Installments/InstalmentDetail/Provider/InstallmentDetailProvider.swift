//  Created by Assylkhan Turan on 27.07.2022.

import AlfaNetworking
import SharedPromiseKit

protocol ProvidesInstallmentDetail {
    func getInstallment(model: InstallmentDetailsContext.PlainModel) -> Promise<[Instalment]>
    func getInstallmentDetailContext() -> InstallmentDetailsContext
}

final class InstallmentDetailProvider: ProvidesInstallmentDetail {
    private var dataStore: StoresInstallmentDetailContext
    private let service: InstalmentListServiceType

    init(
        dataStore: StoresInstallmentDetailContext,
        service: InstalmentListServiceType
    ) {
        self.dataStore = dataStore
        self.service = service
    }

    // MARK: - ProvidesInstallmentDetail

    func getInstallment(model: InstallmentDetailsContext.PlainModel) -> Promise<[Instalment]> {
        service
            .sendRequest(pathContext: model.installmentType)
            .get { [weak self] installments in
                guard let installment = installments.first(
                    where: { $0.uid == model.uid && $0.agreementNumber == model.agreementNumber }
                )
                else { return }

                self?.dataStore.context = .full(InstallmentDetailsModel(
                    installment: installment,
                    installmentType: model.installmentType,
                    isSeveralInstallments: installments.count > 1
                ))
            }
    }

    func getInstallmentDetailContext() -> InstallmentDetailsContext { dataStore.context }
}
