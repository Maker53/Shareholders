//  Created by Assylkhan Turan on 25.07.2022.

/// Контекст для открытия деталки рассрочки
@frozen
public enum InstallmentDetailsContext: Equatable {
    /// При открытии сразу с моделькой деталки
    case full(InstallmentDetailsModel)
    /// При открытии с неполной информацией. Делает запрос и загружает детальную информацию рассрочки
    case plain(PlainModel)

    // MARK: Public

    public struct PlainModel: Equatable {
        let uid: String
        let agreementNumber: String
        let installmentType: InstallmentType

        public init(
            uid: String,
            agreementNumber: String,
            installmentType: InstallmentType
        ) {
            self.uid = uid
            self.agreementNumber = agreementNumber
            self.installmentType = installmentType
        }
    }
}

public struct InstallmentDetailsModel: Equatable {
    let installment: Instalment
    let installmentType: InstallmentType
    let isSeveralInstallments: Bool
}
