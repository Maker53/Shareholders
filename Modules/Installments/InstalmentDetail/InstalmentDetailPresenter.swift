//  Created by Lyudmila Danilchenko on 25/10/2020.

import ABUIComponents
import AlfaFoundation
import AMSharedProtocolsAndModels
import SharedProtocolsAndModels

protocol InstalmentDetailPresentationLogic: AnyObject {
    func presentError(_ errorType: InstalmentDetail.ErrorType)
    func presentData(_ response: InstalmentDetail.PresentModuleData.Response)
    func presentDebitRepayment()
    func presentDebitDialog(_ response: InstalmentDetail.PresentDebitDialog.Response)
    func presentInfoDialog()
    func presentTransfer()
    func presentCancelInstallment(_ response: InstalmentDetail.PresentCancelInstalment.Response)
}

final class InstalmentDetailPresenter: InstalmentDetailPresentationLogic {
    func presentDebitDialog(_ response: InstalmentDetail.PresentDebitDialog.Response) {
        
    }
    
    func presentInfoDialog() {
        
    }
    
    // MARK: - Properties

    struct Appearance: Theme { }
    private let appearance = Appearance()
    weak var viewController: InstalmentDetailDisplayLogic?

    let featureService: FeaturesServiceProtocol
    let worker: InstallmentDetailPresenterWorkerProtocol

    // MARK: - init

    init(
        featureService: FeaturesServiceProtocol,
        worker: InstallmentDetailPresenterWorkerProtocol = InstallmentDetailPresenterWorker()
    ) {
        self.featureService = featureService
        self.worker = worker
    }

    // MARK: - InstalmentDetailPresentationLogic

    func presentError(_: InstalmentDetail.ErrorType) { }

    func presentData(_ response: InstalmentDetail.PresentModuleData.Response) {
        let isFeatureEnabled: Bool
        switch response.installmentType {
        case .credit:
            isFeatureEnabled = featureService.enabled(InstallmentsFeature.creditCardsPlanItEarlyRepayment)
        case .debit, .promotional:
            isFeatureEnabled = featureService.enabled(AMSharedFeature.debitInstallment)
        }

        let shouldHideRepayment = !isFeatureEnabled || response.installment.isCancellationAvailable

        let viewModel = InstalmentDetail.PresentModuleData.ViewModel(
            sections: sections(for: response.installment, with: response.installmentType, and: isFeatureEnabled),
            shouldEnableRepayment: response.installment.earlyRepaymentAvailable,
            shouldHideRepayment: shouldHideRepayment,
            title: response.installment.title
        )
        viewController?.displayData(viewModel)
    }

    func presentDebitRepayment() {
        viewController?.displayTransfer()
    }

    func presentTransfer() {
        viewController?.displayTransfer()
    }

    func presentCancelInstallment(_ response: InstalmentDetail.PresentCancelInstalment.Response) {
        viewController?.displayCancelInstalment(
            .init(cancelInstallmentContext: response.cancelInstallmentContext)
        )
    }
}

private extension InstalmentDetailPresenter {
    func sections(for installment: Instalment, with installmentType: InstallmentType, and isFeatureAvailable: Bool) -> [DetailInfoSection] {
        let dataSection = worker.makeDataSections(installment: installment, installmentType: installmentType)
        let repaymentSection = worker.makeEarlyRepaymentSections(
            installment: installment,
            installmentType: installmentType,
            isFeatureAvailable: isFeatureAvailable
        )
        return dataSection + repaymentSection
    }
}
