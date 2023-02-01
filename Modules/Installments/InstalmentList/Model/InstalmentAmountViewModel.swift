//  Created by Lyudmila Danilchenko on  23.09.2020.

///  InstalmentAmountViewModel:
///
///   Осталось выплатить (title)
///   40 000,50 руб (amount)
///   ========--------------------------------------- (progress)
///   10 000 руб (amountProgressLeft)   50 000,50 руб (amountProgressRight)
///
import ABUIComponents

/// Вьюмодель для вьюхи, отображающей информацию по суммам и платежам рассрочки с прогресс-баром
public struct InstalmentAmountViewModel: AmountProgressViewModelRepresentable {
    public let dataContentViewModel: DataContentViewModel
    public let progress: Double
    public let amountProgressLeft: String
    public let amountProgressRight: String

    public init(
        dataContentViewModel: DataContentViewModel,
        progress: Double,
        amountProgressLeft: String,
        amountProgressRight: String
    ) {
        self.dataContentViewModel = dataContentViewModel
        self.progress = progress
        self.amountProgressLeft = amountProgressLeft
        self.amountProgressRight = amountProgressRight
    }
}

// MARK: - Equatable

extension InstalmentAmountViewModel: Equatable {
    public static func == (lhs: InstalmentAmountViewModel, rhs: InstalmentAmountViewModel) -> Bool {
        lhs.dataContentViewModel == rhs.dataContentViewModel
            && lhs.progress == rhs.progress
            && lhs.amountProgressLeft == rhs.amountProgressLeft
            && lhs.amountProgressRight == rhs.amountProgressRight
    }
}
