struct InstallmentListSection: Equatable {
    let title: String?
    let cells: [Cell]

    enum Cell: Equatable {
        case installment(InstalmentListCellViewModel)
        case debitInstallment(InstalmentListCellViewModel)
        case amount(DataViewModel)
    }
}
