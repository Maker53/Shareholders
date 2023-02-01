///  Created by Roman Turov on 16/04/2019.

import ABUIComponents
import SharedProtocolsAndModels

/// Вью модель для отображения ячеек города, метро и отделения
struct OfficeChangingViewModel: Equatable {
    /// Вью модель ячейки
    let pickerViewModel: PickerCellViewModel
    /// Тип ячейки
    let row: OfficeChangingRowType
}

/// Типы ячеек
enum OfficeChangingRowType: Equatable {
    case city
    case metro
    case office
}

struct OfficeChangingCellViewModel: ActionCellViewModel, Equatable {
    var image: ImageSource?
    var title: String
    var subtitle: String?
    var isSeparatorHidden: Bool {
        get { true }
        set { _ = newValue }
    }

    init(
        image: UIImage? = nil,
        title: String,
        subtitle: String? = nil
    ) {
        self.image = ImageSource(placeholder: image)
        self.title = title
        self.subtitle = subtitle
    }
}
