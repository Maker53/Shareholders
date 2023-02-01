//
//  StartFactory.swift
//  AlfaOnboarding
//
//  Created by Vasily Ponomarev on 06/12/2019.
//  Copyright © 2019 Alfa-Bank. All rights reserved.
//

import SharedRouter

final class StartFactory: Factory {
    typealias Context = ()
    typealias ViewController = StartViewController

    let builder: StartBuilder
    let routes: StartRoutes.Type

    init(
        builder: StartBuilder = StartBuilder(),
        routes: StartRoutes.Type
    ) {
        self.builder = builder
        self.routes = routes
    }

    func build(with _: Context) throws -> StartViewController {
        builder.setRoutes(routes).build()
    }
}
