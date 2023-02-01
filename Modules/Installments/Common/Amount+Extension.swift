//  Created by Наталья on 20.07.2018.

import ABUIComponents
import SharedProtocolsAndModels

// MARK: - convenience initializers

//  Временные расширения для Amount
// TODO: сжечь расширения ниже, как только вмерджат более чистый форматтер, не использующий Amount(soon)

public extension ComponentAmount {
    init(amount: Amount) {
        self.init(
            amount.withoutMinorUnits,
            minorUnits: amount.minorUnits,
            currency: amount.currency
        )
    }
}

public extension Amount {
    init(componentsAmount: ComponentAmount) {
        self.init(
            componentsAmount.withoutMinorUnits,
            minorUnits: componentsAmount.minorUnits,
            currency: componentsAmount.currency
        )
    }
}

// MARK: - Formattable

public protocol Formattable {
    func totalAmount(integerPartFont: UIFont?, fractionalPartFont: UIFont?) -> NSAttributedString?
}

// MARK: - ComponentAmount + Formattable

extension ComponentAmount: Formattable {
    public var string: String? {
        let formatter = AmountFormatter()
        // Если в сумме присутствуют копейки, то всегда отображать 2 числа после точки
        if !withoutMinorUnits.isMultiple(of: minorUnits) {
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
        }
        formatter.currencySymbol = currency.symbol
        return formatter.string(for: self).map(formatter.appendCurrencySymbol)
    }

    public func totalAmount(integerPartFont: UIFont?, fractionalPartFont: UIFont?) -> NSAttributedString? {
        guard let formattedAmount = string else { return nil }
        guard let integerPartFont = integerPartFont, let fractionalPartFont = fractionalPartFont else {
            return NSAttributedString(string: formattedAmount)
        }

        let formatter = AmountFormatter()
        formatter.currencySymbol = currency.symbol
        return formatter.applyAttributes(
            to: formattedAmount,
            integerPartFont: integerPartFont,
            fractionalPartFont: fractionalPartFont
        )
    }
}

// MARK: - Amount + Formattable

extension Amount: Formattable {
    public func totalAmount(integerPartFont: UIFont?, fractionalPartFont: UIFont?) -> NSAttributedString? {
        ComponentAmount(amount: self).totalAmount(integerPartFont: integerPartFont, fractionalPartFont: fractionalPartFont)
    }
}

// MARK: - String + Formattable

extension String: Formattable {
    public func totalAmount(integerPartFont: UIFont?, fractionalPartFont: UIFont?) -> NSAttributedString? {
        let formatter = AmountFormatter()
        let string = trimmed()
        if let currencySymbolCandidate = string.last.map(String.init),
           let currency = CurrencyParser.currency(for: currencySymbolCandidate) {
            formatter.currencySymbol = currency.symbol
        }
        return formatter.stringToComponentAmount(string: string).flatMap {
            $0.totalAmount(integerPartFont: integerPartFont, fractionalPartFont: fractionalPartFont)
        }
    }
}
