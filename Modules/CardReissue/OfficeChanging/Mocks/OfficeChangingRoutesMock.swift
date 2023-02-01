//  Created by Roman Turov on 26/04/2019.

import SharedRouter

class OfficeChangingRoutesMock: OfficeChangingRoutes {
    static var alertWasCalled = 0
    static func alert(title _: String, message _: String, actions _: [UIAlertAction], style _: UIAlertController.Style) -> Route {
        alertWasCalled += 1
        return SharedRouter.Route { _ in }
    }

    static var backWasCalled = 0
    static func back() -> SharedRouter.Route {
        backWasCalled += 1
        return SharedRouter.Route { _ in }
    }
}
