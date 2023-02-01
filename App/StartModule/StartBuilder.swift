//
//  StartBuilder.swift
//  AlfaOnboarding
//
//  Created by Vasily Ponomarev on 06/12/2019.
//  Copyright © 2019 Alfa-Bank. All rights reserved.
//

import AlfaFoundation

final class StartBuilder: ModuleBuilder {
    var routes: StartRoutes.Type?

    init() { }

    func setRoutes(_ routes: StartRoutes.Type?) -> Self {
        self.routes = routes
        return self
    }

    func build() -> StartViewController {
        guard let routes = routes else { preconditionFailure("Parameters were not set") }
        return StartViewController(routes: routes)
    }
}
