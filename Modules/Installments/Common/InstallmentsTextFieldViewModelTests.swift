//  Created by Lyudmila Danilchenko on 17.12.2020.

import ABUIComponents
import SharedProtocolsAndModels
import SharedWorkers
import TestAdditions

@testable import Installments

final class InstallmentsTextFieldViewModelTests: QuickSpec {
    override func spec() {
        describe(".init") {
            it("should set default parameters") {
                // when
                let model = InstallmentsTextFieldViewModel(
                    errorMessage: TestData.errorMessage,
                    formatter: TestData.formatter,
                    hint: TestData.hint,
                    keyboardType: TestData.keyboardType,
                    placeholder: TestData.placeholder,
                    text: TestData.text,
                    title: TestData.title
                )

                // then
                expect(model.errorMessage).to(equal(TestData.errorMessage))
                expect(model.hint).to(beNil())
                expect(model.keyboardType).to(equal(TestData.keyboardType))
                expect(model.placeholder).to(equal(TestData.placeholder))
                expect(model.text).to(equal(TestData.text))
                expect(model.title).to(equal(TestData.title))
                expect(model.isEnabled).to(equal(TestData.isEnabled))
                expect(model.showClearButton).to(equal(TestData.showClearButton))
                expect(model.autocorrectionType).to(equal(.no))
            }
        }

        describe(".equality") {
            context("two values are equal") {
                it("should return true") {
                    // given
                    let lhs = TestData.model
                    let rhs = TestData.model
                    // when
                    let result = lhs == rhs
                    // then
                    expect(result).to(beTrue())
                }
            }

            context("two values are not equal") {
                it("should return false with other keyboardType") {
                    // given
                    let lhs = TestData.model
                    let rhs = TestData.otherKeyboardTypeModel
                    // when
                    let result = lhs == rhs
                    // then
                    expect(result).to(beFalse())
                }

                it("should return false with other formatter") {
                    // given
                    let lhs = TestData.model
                    let rhs = TestData.otherFormatterModel
                    // when
                    let result = lhs == rhs
                    // then
                    expect(result).to(beFalse())
                }
            }
        }
    }
}

private extension InstallmentsTextFieldViewModelTests {
    enum TestData {
        static let model = InstallmentsTextFieldViewModel(
            errorMessage: errorMessage,
            formatter: formatter,
            hint: hint,
            keyboardType: keyboardType,
            placeholder: placeholder,
            title: title
        )
        static let otherKeyboardTypeModel = InstallmentsTextFieldViewModel(
            errorMessage: errorMessage,
            formatter: formatter,
            hint: hint,
            keyboardType: otherKeyboardType,
            placeholder: placeholder,
            title: title
        )
        static let otherFormatterModel = InstallmentsTextFieldViewModel(
            errorMessage: errorMessage,
            formatter: otherFormatter,
            hint: hint,
            keyboardType: keyboardType,
            placeholder: placeholder,
            title: title
        )

        static let errorMessage = "errorMessage"
        static let formatter = CommonTextFieldFormatter()
        static let otherFormatter = PhoneTextFieldFormatter(
            PartialPhoneNumberFormatter(phoneNumberKitFacade: PhoneNumberKitFacadeMock())
        )
        static let hint: String? = nil
        static let placeholder = "placeholder"
        static let keyboardType: UIKeyboardType = .decimalPad
        static let otherKeyboardType: UIKeyboardType = .emailAddress
        static let text = "text"
        static let title = "title"
        static let isEnabled = true
        static let showClearButton = false
    }
}
