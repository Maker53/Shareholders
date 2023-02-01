//  Фасад, который предоставляет интерфейс для общения с JMBA
//  Created by Alexander Dubikov on 31/05/2018.
//

import AlfaFoundation
import AlfaNetworking

final class JMBAFacade {
    let jmbaManager: ABOnlineBankManager

    init(jmbaManager: ABOnlineBankManager) {
        self.jmbaManager = jmbaManager
    }

    func doRequestCardSetStatus(_ status: AMCardBlockStatus, of cardID: String, isVirtual: Bool) {
        jmbaManager.doRequestCardSetStatus(status, of: cardID, virtual: isVirtual)
    }

    func doRequestCardSetStatus(_ status: AMCardBlockStatus, isVirtual: Bool, confirm: String, password: String?) {
        jmbaManager.doRequestCardSetStatus(status, virtual: isVirtual, confirm: confirm, password: password)
    }
}

// MARK: - JMBAFacadeProtocol

extension JMBAFacade: JMBAFacadeProtocol {
    var isDemoMode: Bool {
        jmbaManager.isDemoMode()
    }

    var notificationsList: [AnyObject] {
        guard let list = jmbaManager.notificationsList as [AnyObject]? else {
            return []
        }
        return list
    }

    func doRequestGetOperationReceipt(inPDF: String) {
        jmbaManager.doRequestGetOperationReceipt(inPDF: inPDF)
    }

    func doGetExchangeRate(
        from debitCurrency: String?,
        to creditCurrency: String?,
        parameters: [AnyHashable: Any]
    ) {
        jmbaManager.doGetExchangeRate(
            withDebitCurr: debitCurrency,
            creditCurrency: creditCurrency,
            parameters: parameters
        )
    }

    func amountCorrect(_ input: String?, error: inout ErrorCode) -> String? {
        var localError = ABErrorCode(rawValue: error.rawValue) ?? .ABErrorNone

        return jmbaManager.amountCorrect(
            input,
            error: &localError
        )
    }

    func doRequestTransferRegister(
        _ type: String?,
        parameters: [AnyHashable: Any]
    ) {
        jmbaManager.doRequestTransferRegister(
            type,
            parameters: parameters
        )
    }

    func logout() {
        jmbaManager.logout()
    }

    func doRequestUnlockFullVersion() { }

    func doRequestAgreeWithPassport(notificationID: String?, parameters: [AnyHashable: Any]) {
        jmbaManager.doRequestAgree(withPassportNotification: notificationID, parameters: parameters)
    }

    func setDemoMode(active: Bool) {
        jmbaManager.setDemoMode(active)
    }

    func doRequestGetVIPManagerInfo() {
        jmbaManager.doRequestGetVIPManagerInfo()
    }

    func doRequestCardRemapInit() {
        jmbaManager.doRequestCardRemapInit()
    }

    func doRequestCardRemap(_ cardID: String, to account: String) {
        jmbaManager.doRequestCardRemap(cardID, to: account)
    }

    func doRequestCardRemapConfirm(_ reference: String, password: String?) {
        jmbaManager.doRequestCardRemapConfirm(reference, password: password)
    }

    func doRequestSuspendTokens(_ parameters: [AnyHashable: Any]!) { // swiftlint:disable:this implicitly_unwrapped_optional
        jmbaManager.doRequestSuspendTokens(parameters)
    }

    func doRequestVCardDelete(_ icard: String) {
        jmbaManager.doRequestVCardDelete(icard)
    }

    func doRequestVCardDeleteConfirm(_ iuid: String, password: String?) {
        jmbaManager.doRequestVCardDeleteConfirm(iuid, password: password)
    }

    func doRequestVCardCVC2Info(_ cardID: String) {
        jmbaManager.doRequestVCardCVC2Info(cardID)
    }

    func doRequestTransferConfirm(withType type: String, md: String, paRes: String) {
        jmbaManager.doRequestTransferConfirm(withType: type, md: md, paRes: paRes)
    }

    func doRequestFastCalculateFee(
        _ cardNumber: String?,
        fromCardID: String?,
        cardID: String,
        recipientType: String
    ) {
        jmbaManager.doRequestFastCalculateFee(
            cardNumber,
            fromCardID: fromCardID,
            cardID: cardID,
            recipientType: recipientType
        )
    }
}
