//  Created by Lyudmila Danilchenko on 17/08/2020.

import AlfaFoundation
import SharedRouter

public protocol InstalmentListRoutes {
    /// Маршрут для возврата на предыдущий экран
    static func back() -> SharedRouter.Route

    /// Маршрут для закрытия верхнего экрана
    static func dismiss() -> SharedRouter.Route

    /// Маршрут на детальную информацию о рассрочке
    static func instalmentDetails(with context: InstallmentDetailsContext) -> SharedRouter.Route

    /// Маршрут для открытия action sheet с выбором типа открываемой рассрочки
    static func alert(text: UIAlertText, actions: [UIAlertAction]?, style: UIAlertRouteStyle) -> SharedRouter.Route
}
