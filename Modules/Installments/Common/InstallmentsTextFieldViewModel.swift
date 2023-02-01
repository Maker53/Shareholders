//  Created by Виталий Рамазанов on 01.03.2021.

import ABUIComponents

/// Вьюмодель для поля ввода суммы
struct InstallmentsTextFieldViewModel: TextFieldViewModelRepresentable, Equatable {
    static func == (lhs: InstallmentsTextFieldViewModel, rhs: InstallmentsTextFieldViewModel) -> Bool {
        lhs.errorMessage == rhs.errorMessage
            && type(of: lhs.formatter) == type(of: rhs.formatter)
            && lhs.hint == rhs.hint
            && lhs.isEnabled == rhs.isEnabled
            && lhs.keyboardType == rhs.keyboardType
            && lhs.placeholder == rhs.placeholder
            && lhs.showClearButton == rhs.showClearButton
            && lhs.text == rhs.text
            && lhs.title == rhs.title
            && lhs.autocorrectionType == rhs.autocorrectionType
    }

    let errorMessage: String?
    let formatter: TextFieldFormatterProtocol
    let hint: String?
    var isEnabled: Bool = true
    let keyboardType: UIKeyboardType
    let placeholder: String?
    var showClearButton: Bool = false
    var text: String?
    let title: String?
    let autocorrectionType: UITextAutocorrectionType = .no
}
