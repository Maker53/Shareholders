//  Created by Roman Turov on 25/04/2019.

import SharedRouter

/// Переходы с экрана смены отделения доставки
public protocol OfficeChangingRoutes {
    /// Переход назад
    static func back() -> SharedRouter.Route

    /// Переход на AlertController
    static func alert(
        title: String,
        message: String,
        actions: [UIAlertAction],
        style: UIAlertController.Style
    ) -> SharedRouter.Route
}
