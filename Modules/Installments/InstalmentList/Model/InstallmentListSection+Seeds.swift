extension InstallmentListSection {
    enum Seeds {
        static let value = InstallmentListSection(
            title: "Section",
            cells: [
                .installment(InstalmentListCellViewModel.Seeds.value),
                .installment(InstalmentListCellViewModel.Seeds.value),
            ]
        )
    }
}
