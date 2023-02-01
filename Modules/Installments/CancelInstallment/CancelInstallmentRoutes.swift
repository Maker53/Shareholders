//  Created by Рамазанов Виталий Глебович on 27/08/2021.

import AlfaFoundation
import OperationConfirmation
import ResultScreen
import SharedRouter

public protocol CancelInstallmentRoutes {
    /// Маршрут для закрытия верхнего экрана
    static func dismiss() -> SharedRouter.Route

    /// Маршрут для показа PDF-документов
    static func openPDF(localURL: URL) -> SharedRouter.Route

    /// Маршрут алерта с ошибкой
    static func errorAlert(
        with message: String,
        actionHandler: (() -> Void)?
    ) -> SharedRouter.Route

    /// Маршрут для перехода на новый ResultScreen
    static func resultScreen(model: ResultScreenModel) -> SharedRouter.Route

    /// Маршрут для показа экрана подтверждения
    static func openOperationConfirmation(
        with configuration: OperationConfirmationPartialConfiguration
    ) -> SharedRouter.Route

    static func instalmentsList() -> SharedRouter.Route
}
