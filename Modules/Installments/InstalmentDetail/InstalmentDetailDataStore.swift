protocol StoresInstallmentDetailContext {
    var context: InstallmentDetailsContext { get set }
}

final class InstallmentDetailDataStore: StoresInstallmentDetailContext {
    var context: InstallmentDetailsContext

    init(context: InstallmentDetailsContext) {
        self.context = context
    }
}
