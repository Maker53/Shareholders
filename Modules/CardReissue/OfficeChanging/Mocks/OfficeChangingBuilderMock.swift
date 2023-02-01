class OfficeChangingBuilderMock: OfficeChangingBuilder {
    var setCardIDWasCalled = 0
    var setRoutesWasCalled = 0

    override func setCardID(_ cardID: String) -> Self {
        setCardIDWasCalled += 1
        self.cardID = cardID
        return self
    }

    override func setRoutes(_ routes: OfficeChangingRoutes.Type?) -> Self {
        setRoutesWasCalled += 1
        self.routes = routes
        return self
    }
}
