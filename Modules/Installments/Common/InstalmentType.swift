/// Виды рассрочек
@frozen
public enum InstallmentType: String, Equatable, CaseIterable {
    /// Кредитная
    case credit = "cc"
    /// Дебетовая
    case debit = "dc"
    /// Дебетовая акционная
    case promotional = "dcp"
}
