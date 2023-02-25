// Created by Станислав on 07.02.2023.

import AlfaFoundation
import SharedRouter

public protocol ShareholderListRoutes {
    static func shareholderDetails(uid: UniqueIdentifier) -> Route
}
