import AMSharedProtocolsAndModels

/// Основные фиче-флаги модуля рассрочки.
@frozen
public enum InstallmentsFeature: String, FeatureFlag {
    /// Досрочное погашение рассрочки по кредитной карте
    case creditCardsPlanItEarlyRepayment
    /// Функциональнсть по БКИ.
    case debitInstallmentRecalculation
}
