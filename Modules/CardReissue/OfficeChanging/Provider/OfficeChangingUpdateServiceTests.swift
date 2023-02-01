//
//  SUT: OfficeChangingUpdateService
//

import AlfaNetworking
import NetworkKit
import TestAdditions

@testable import CardReissue

final class OfficeChangingUpdateServiceTests: QuickSpec {
    override func spec() {
        var service: OfficeChangingUpdateService!
        var apiClientMock: APIClientMock!

        beforeEach {
            apiClientMock = APIClientMock()
            service = OfficeChangingUpdateService(apiClient: apiClientMock)
        }

        describe(".updateReissuesOffice") {
            it("should call apiClientMock") {
                // when
                service.updateReissuesOffice(cardID: TestData.cardID, officeID: TestData.officeID) { _ in }
                // then
                expect(apiClientMock.executeWasCalled).to(beCalledOnce())
                expect(apiClientMock.executeArguments?.request?.endpoint).to(equal(TestData.endpoint))
                expect(apiClientMock.executeArguments?.request?.parameters["officeId"] as! String?).to(equal(TestData.officeID))
            }

            it("should return valid response") {
                // given
                var result: RResult<Any, ServiceError>?
                apiClientMock.executeCallbackStub = .success("1")
                // when
                service.updateReissuesOffice(cardID: TestData.cardID, officeID: TestData.officeID) { result = $0 }
                // then
                expect(result?.value).toEventuallyNot(beNil())
                expect(result?.error).toEventually(beNil())
            }

            it("should return error") {
                // given
                var result: RResult<Any, ServiceError>?
                apiClientMock.executeCallbackStub = .failure(APIClientError.other)
                // when
                service.updateReissuesOffice(cardID: TestData.cardID, officeID: TestData.officeID) { result = $0 }
                // then
                expect(result?.value).toEventually(beNil())
                expect(result?.error).toEventuallyNot(beNil())
            }
        }
    }
}

private extension OfficeChangingUpdateServiceTests {
    enum TestData {
        static let cardID = "123123"
        static let officeID = "666"
        static let params: [String: Any] = ["officeId": officeID]
        static let endpoint = "v1/cards/123123/issuing-office"
    }
}
