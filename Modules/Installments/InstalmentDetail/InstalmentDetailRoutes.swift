//  Created by Lyudmila Danilchenko on 25/10/2020.

import ABUIComponents
import AlfaFoundation
import SharedRouter

public protocol InstalmentDetailRoutes {
    /// Маршрут для возврата на предыдущий экран
    static func back() -> SharedRouter.Route
    /// Экран переводов
    static func transfer(source: String?, destination: String?) -> SharedRouter.Route
    /// Маршрут для экрана отмены рассрочки
    static func cancelInstallment(with context: CancelInstallmentContext) -> SharedRouter.Route
}
