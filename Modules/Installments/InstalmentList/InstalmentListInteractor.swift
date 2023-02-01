//  Created by Lyudmila Danilchenko on 17/08/2020.

import ABUIComponents
import AlfaNetworking
import AMSharedProtocolsAndModels
import SharedPromiseKit

protocol InstalmentListBusinessLogic: AnyObject {
    func openNewInstalment()
    func loadData(_ request: InstalmentList.PresentModuleData.Request)
    func openInstallmentDetails(_ request: InstalmentList.PresentInstallmentDetails.Request)
}

final class InstalmentListInteractor: InstalmentListBusinessLogic {
    // MARK: - Properties

    let presenter: InstalmentListPresentationLogic
    let provider: ProvidesInstalmentList
    let featuresService: FeaturesServiceProtocol

    // MARK: - Lifecycle

    init(
        presenter: InstalmentListPresentationLogic,
        provider: ProvidesInstalmentList,
        featuresService: FeaturesServiceProtocol
    ) {
        self.presenter = presenter
        self.provider = provider
        self.featuresService = featuresService
    }

    // MARK: - InstalmentListBusinessLogic

    func loadData(_ request: InstalmentList.PresentModuleData.Request) {
        let shouldRequestDebit = featuresService.enabled(AMSharedFeature.debitInstallment)
        let shouldRequestCredit = featuresService.enabled(AMSharedFeature.creditCardsPlanIt)

        let debitInstallmentsPromise = shouldRequestDebit
            ? provider.getInstalments(installmentType: .debit, usingCache: !request.shouldRefreshInstalments)
            : .value([])
        let debitOffersPromise = shouldRequestDebit
            ? provider.getInstalmentOffers(context: .init(installmentType: .debit, operationID: nil))
            : .value(.init(instalmentOffers: [], shouldShowLanding: false))

        let creditInstallmentsPromise = shouldRequestCredit
            ? provider.getInstalments(installmentType: .credit, usingCache: !request.shouldRefreshInstalments)
            : .value([])
        let creditOffersPromise = shouldRequestCredit
            ? provider.getInstalmentOffers(context: .init(installmentType: .credit, operationID: nil))
            : .value(.init(instalmentOffers: [], shouldShowLanding: false))

        firstly {
            when(fulfilled: creditInstallmentsPromise, debitInstallmentsPromise, creditOffersPromise, debitOffersPromise)
        }.done { [weak self] creditInstallments, debitInstallments, creditOffers, debitOffers in
            self?.handleResponse(
                creditInstallments: creditInstallments,
                debitInstallments: debitInstallments,
                creditOffers: creditOffers,
                debitOffers: debitOffers
            )
        }.catch { [weak self] in
            self?.presenter.presentError(.init(description: $0.localizedDescription))
            ABLogError($0.localizedDescription)
        }
    }

    func openNewInstalment() {
        let debitPromise = featuresService.enabled(AMSharedFeature.debitInstallment)
            ? provider.getInstalmentOffers(context: .init(installmentType: .debit, operationID: nil))
            : .value(.init(instalmentOffers: [], shouldShowLanding: false))
        let creditPromise = featuresService.enabled(AMSharedFeature.creditCardsPlanIt)
            ? provider.getInstalmentOffers(context: .init(installmentType: .credit, operationID: nil))
            : .value(.init(instalmentOffers: [], shouldShowLanding: false))

        firstly {
            when(fulfilled: creditPromise, debitPromise)
        }.done { [weak self] creditOffers, debitOffers in
            self?.presenter.presentNewInstalment(
                .init(
                    creditOffers: creditOffers,
                    debitOffers: debitOffers
                )
            )
        }.catch { [weak self] in
            self?.presenter.presentError(.init(description: Resources.L10n.APIClientError.somethingWentWrong))
            ABLogError($0.localizedDescription)
        }
    }

    func openInstallmentDetails(_ request: InstalmentList.PresentInstallmentDetails.Request) {
        firstly {
            provider.getInstalments(installmentType: request.installmentType, usingCache: true)
        }.done { [weak self] response in
            self?.presenter.presentInstallmentDetails(
                .full(.init(
                    installment: request.installment,
                    installmentType: request.installmentType,
                    isSeveralInstallments: response.count > 1
                ))
            )
        }.catch { [weak self] in
            self?.presenter.presentError(.init(description: Resources.L10n.APIClientError.somethingWentWrong))
            ABLogError($0.localizedDescription)
        }
    }
}

private extension InstalmentListInteractor {
    func handleResponse(
        creditInstallments: [Instalment],
        debitInstallments: [Instalment],
        creditOffers: InstalmentOfferResponse,
        debitOffers: InstalmentOfferResponse
    ) {
        let shouldPresentPlusButton = creditOffers.instalmentOffers.isNotEmpty || debitOffers.instalmentOffers.isNotEmpty
        presenter.presentPlusButton(.init(shouldPresentButton: shouldPresentPlusButton))

        let installments = creditInstallments + debitInstallments

        let totalPaymentSum = installments.reduce(into: 0) { accumulator, installment in
            accumulator += installment.paymentInfo.payment.paymentAmount.withoutMinorUnits
        }

        let paymentAmount = Amount(totalPaymentSum, minorUnits: 100, currency: .rub)

        let offersState: InstalmentList.PresentEmptyState.OffersState
        switch (creditOffers.instalmentOffers.isEmpty, debitOffers.instalmentOffers.isEmpty) {
        case (false, false):
            offersState = [.hasCreditOffer, .hasDebitOffer]
        case (false, true):
            offersState = [.hasCreditOffer]
        case (true, false):
            offersState = [.hasDebitOffer]
        case (true, true):
            offersState = []
        }

        if creditInstallments.isEmpty, debitInstallments.isEmpty {
            presenter.presentEmptyState(.init(offersState: offersState))
        } else {
            presenter.presentInstalmentList(
                .init(
                    paymentSum: paymentAmount,
                    creditInstallments: creditInstallments,
                    debitInstallments: debitInstallments
                )
            )
        }
    }
}
