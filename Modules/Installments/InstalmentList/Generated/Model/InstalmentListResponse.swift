//
// InstalmentListResponse Model
// Generated on 17/09/2020 by gen v0.4.0
//

import AlfaFoundation

/// Модель списка рассрочек
struct InstalmentListResponse: Equatable {
    /// Массив моделей рассрочек
    let instalments: [Instalment]
}
