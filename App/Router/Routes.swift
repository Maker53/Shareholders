//
//  Routes.swift
//  AlfaOnboarding
//
//  Created by Bulat Khabirov on 01/11/2019.
//  Copyright © 2019 Alfa-Bank. All rights reserved.
//

import AlfaFoundation
import SharedRouter

public extension Routes {
    /// Метод создает DestinationStep со следующими настройками:
    /// - в качестве factory будет использован переданный объект,
    /// - в качестве finder будет использован DefaultFinderByClassName,
    /// - использует LoginInterceptor,
    /// - контроллер будет показан методом push,
    /// - контроллер будет показан из любого NavigationController'а, найденного в иерархии ViewController'ов
    static func defaultStep<F: Factory>(
        factory: F,
        finder: DefaultClassFinder<F.ViewController, F.Context> = F.DefaultFinderByClassName(),
        options: SearchOptions = .allVisible,
        feature _: AnyFeature? = nil
    ) -> DestinationStep<F.ViewController, F.Context> {
        StepAssembly(finder: finder, factory: factory)
            .using(UINavigationController.push())
            .from(SingleContainerStep(
                finder: ClassFinder<UINavigationController, F.Context>(options: options),
                factory: NavigationControllerFactory()
            ))
            .using(NilAction())
            .from(GeneralStep.current())
            .assemble()
    }
}

// MARK: - Routes + StartRoutes

extension Routes: StartRoutes {
    static func shareholdersList() -> SharedRouter.Route {
        SharedRouter.Route { _ in
        }
    }
}
