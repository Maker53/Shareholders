import ABUIComponents
import SharedProtocolsAndModels

struct CancelInstallmentSection: Equatable, SectionViewModelRepresentable {
    let header: String?
    let rows: [Row]

    enum Row: Equatable {
        case textView(TextView.ViewModel)
        case comissionRefund(DataViewModel)
        case redText(DataViewModel)
        case document(DataViewModel)
        case input(InstallmentsTextFieldViewModel)
    }
}
