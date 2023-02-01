///  Created by Roman Turov on 16/04/2019.

import SharedRouter

public class OfficeChangingFactory: Factory {
    let builder: OfficeChangingBuilder
    let routes: OfficeChangingRoutes.Type

    public typealias Context = (
        cardID: String,
        delegateBlock: (() -> Void)?
    )

    public init(
        builder: OfficeChangingBuilder = OfficeChangingBuilder(),
        routes: OfficeChangingRoutes.Type
    ) {
        self.builder = builder
        self.routes = routes
    }

    public func build(with context: Context) throws -> OfficeChangingViewController {
        builder
            .setCardID(context.cardID)
            .setDelegateBlock(context.delegateBlock)
            .setRoutes(routes)
            .build()
    }
}
