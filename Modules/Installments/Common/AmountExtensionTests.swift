//  Created by Elena Gordienko on 15/08/2018.

import ABUIComponents
import AMSharedProtocolsAndModels
import TestAdditions

@testable import Installments

class AmountExtensionTests: QuickSpec {
    override func spec() {
        beforeEach { }

        context("objects convertation") {
            describe(".converting equal objects") {
                it("should produce equal amount objects") {
                    testAmountConvertationFor(currencyCode: TestData.rublesCode)
                    testAmountConvertationFor(currencyCode: TestData.dollarsCode)
                    testAmountConvertationFor(currencyCode: TestData.eurosCode)
                }
            }
        }

        context("formatting") {
            describe(".components amount string check") {
                it("should be equal") {
                    expectComponentsAmountStringValidity(
                        currencySymbol: TestData.rublesSymbol,
                        currencyCode: TestData.rublesCode
                    ).to(beTrue())
                    expectComponentsAmountStringValidity(
                        currencySymbol: TestData.dollarsSymbol,
                        currencyCode: TestData.dollarsCode
                    ).to(beTrue())
                    expectComponentsAmountStringValidity(
                        currencySymbol: TestData.eurosSymbol,
                        currencyCode: TestData.eurosCode
                    ).to(beTrue())
                }
                it("should not be equal") {
                    expectComponentsAmountStringValidity(
                        currencySymbol: TestData.eurosSymbol,
                        currencyCode: TestData.rublesCode
                    ).to(beFalse())
                    expectComponentsAmountStringValidity(
                        currencySymbol: TestData.rublesSymbol,
                        currencyCode: ""
                    ).to(beFalse())
                    expectComponentsAmountStringValidity(
                        currencySymbol: "",
                        currencyCode: TestData.rublesCode
                    ).to(beFalse())
                }
            }

            describe(".component amount formatting") {
                it("should format rubles correctly") {
                    expectEqualityOfStringFor(
                        formattableObject: TestData.componentAmountFor(currencyCode: TestData.rublesCode),
                        formattedString: TestData.stringWith(
                            amountString: TestData.amountString,
                            currencySymbol: TestData.rublesSymbol
                        )
                    ).to(beTrue())
                }
                it("should format dollars correctly") {
                    expectEqualityOfStringFor(
                        formattableObject: TestData.componentAmountFor(currencyCode: TestData.dollarsCode),
                        formattedString: TestData.stringWith(
                            amountString: TestData.amountString,
                            currencySymbol: TestData.dollarsSymbol
                        )
                    ).to(beTrue())
                }
                it("should not fall back to default currency") {
                    expectEqualityOfStringFor(
                        formattableObject: TestData.componentAmountFor(currencyCode: TestData.dollarsCode),
                        formattedString: TestData.stringWith(
                            amountString: TestData.amountString,
                            currencySymbol: TestData.rublesSymbol
                        )
                    ).to(beFalse())
                }
            }

            describe(".amount formatting") {
                it("should format rubles correctly") {
                    expectEqualityOfStringFor(
                        formattableObject: TestData.amountFor(
                            value: TestData.amountValue,
                            currencyCode: TestData.rublesCode
                        ),
                        formattedString: TestData.stringWith(
                            amountString: TestData.amountString,
                            currencySymbol: TestData.rublesSymbol
                        )
                    ).to(beTrue())
                }
                it("should format rubles without pennies correctly") {
                    expectEqualityOfStringFor(
                        formattableObject: TestData.amountFor(
                            value: TestData.amountValueWithoutPennies,
                            currencyCode: TestData.rublesCode
                        ),
                        formattedString: TestData.stringWith(
                            amountString: TestData.amountStringWithoutPennies,
                            currencySymbol: TestData.rublesSymbol
                        )
                    ).to(beTrue())
                }
                it("should format dollars correctly") {
                    expectEqualityOfStringFor(
                        formattableObject: TestData.amountFor(
                            value: TestData.amountValue,
                            currencyCode: TestData.dollarsCode
                        ),
                        formattedString: TestData.stringWith(
                            amountString: TestData.amountString,
                            currencySymbol: TestData.dollarsSymbol
                        )
                    ).to(beTrue())
                }
                it("should not fall back to default currency") {
                    expectEqualityOfStringFor(
                        formattableObject: TestData.amountFor(
                            value: TestData.amountValue,
                            currencyCode: TestData.dollarsCode
                        ),
                        formattedString: TestData.stringWith(
                            amountString: TestData.amountString,
                            currencySymbol: TestData.rublesSymbol
                        )
                    ).to(beFalse())
                }
            }

            describe(".string formatting") {
                it("should format unformatted string correctly") {
                    expectEqualityOfStringFor(
                        formattableObject: TestData.unformattedString + TestData.rublesSymbol,
                        formattedString: TestData.stringWith(
                            amountString: TestData.amountString,
                            currencySymbol: TestData.rublesSymbol
                        )
                    ).to(beTrue())
                }
                it("should format unformatted string without pennies correctly") {
                    expectEqualityOfStringFor(
                        formattableObject: TestData.unformattedStringWithoutPennies
                            + TestData.rublesSymbol,
                        formattedString: TestData.stringWith(
                            amountString: TestData.amountStringWithoutPennies,
                            currencySymbol: TestData.rublesSymbol
                        )
                    ).to(beTrue())
                }
                it("should leave formatted string intact") {
                    let formattedString = TestData.stringWith(
                        amountString: TestData.amountString,
                        currencySymbol: TestData.dollarsSymbol
                    )
                    expectEqualityOfStringFor(
                        formattableObject: formattedString,
                        formattedString: formattedString
                    ).to(beTrue())
                }
                it("should not fall back to default currency") {
                    expectEqualityOfStringFor(
                        formattableObject: TestData.stringWith(
                            amountString: TestData.amountString,
                            currencySymbol: TestData.dollarsSymbol
                        ),
                        formattedString: TestData.stringWith(
                            amountString: TestData.amountString,
                            currencySymbol: TestData.rublesSymbol
                        )
                    ).to(beFalse())
                }
                it("should not fall back to default currency if currency symbol is unkown") {
                    expectEqualityOfStringFor(
                        formattableObject: TestData.unformattedString + "💩 ",
                        formattedString: TestData.stringWith(
                            amountString: TestData.amountString,
                            currencySymbol: TestData.rublesSymbol
                        )
                    ).to(beFalse())
                }
            }
        }

        func testAmountConvertationFor(currencyCode: String) {
            // given
            let givenAmount = TestData.amountFor(value: TestData.amountValue, currencyCode: currencyCode)
            let givenComponentAmount = TestData.componentAmountFor(currencyCode: currencyCode)
            // when
            let componentAmount = ComponentAmount(amount: givenAmount)
            let amount = Amount(componentsAmount: givenComponentAmount)
            // then
            expect(componentAmount == givenComponentAmount).to(beTrue())
            expect(amount == givenAmount).to(beTrue())
        }

        func expectComponentsAmountStringValidity(
            currencySymbol: String,
            currencyCode: String
        ) -> Expectation<Bool> {
            // given
            let givenComponentAmount = TestData.componentAmountFor(currencyCode: currencyCode)
            let givenString = TestData.stringWith(
                amountString: TestData.amountString,
                currencySymbol: currencySymbol
            )
            // when
            let resultString = givenComponentAmount.string
            // then
            return expect(resultString == givenString)
        }

        func expectEqualityOfStringFor(
            formattableObject: Formattable,
            formattedString: String
        ) -> Expectation<Bool> {
            // when
            let resultString = formattableObject.totalAmount(
                integerPartFont: nil,
                fractionalPartFont: nil
            )?.string
            // then
            return expect(formattedString == resultString)
        }
    }
}

extension AmountExtensionTests {
    enum TestData {
        static let amountString = "123 456,78"
        static let amountStringWithoutPennies = "123 456"
        static let unformattedString = "123456.78"
        static let unformattedStringWithoutPennies = "123456"
        static let amountValue = 12_345_678
        static let amountValueWithoutPennies = 12_345_600
        static let amountMinorUnits = 100
        static let rublesCode = "RUR"
        static let dollarsCode = "USD"
        static let eurosCode = "EUR"
        static let rublesSymbol = "₽"
        static let dollarsSymbol = "$"
        static let eurosSymbol = "€"

        static func stringWith(amountString: String, currencySymbol: String) -> String {
            String(format: "%@\(String.thinSpace)%@", amountString, currencySymbol)
        }

        static func amountFor(value: Int, currencyCode: String) -> Amount {
            Amount(value: value, minorUnits: amountMinorUnits, currency: currencyCode)
        }

        static func componentCurrencyFor(code: String) -> Currency {
            CurrencyParser.currencyFor(code)
        }

        static func componentAmountFor(currencyCode: String) -> ComponentAmount {
            ComponentAmount(
                amountValue,
                minorUnits: amountMinorUnits,
                currency: componentCurrencyFor(code: currencyCode)
            )
        }
    }
}
