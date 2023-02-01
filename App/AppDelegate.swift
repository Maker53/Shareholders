import ABUIComponents
import AlfaNetworking
import OHHTTPStubs
import SharedRouter
import SharedServices

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var imageLoader = ImageLoader.shared

    override init() {
        ExtraFeatures.setup()

        APIClientRegister.setup(
            jmbaManager: JMBAFacade(jmbaManager: ABOnlineBankManager.shared()),
            featuresService: FeatureService.shared,
            keychainService: KeychainService.service()
        )
        super.init()
    }

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        stubResponses()
        configureRootViewController()
        imageLoader.configure(with: NukeImageLoader())
        return true
    }

    private func configureRootViewController() {
        window = UIWindow()
        guard let viewController = try? StartFactory(routes: SharedRouter.Routes.self).build()
        else { fatalError("ViewController not implemented") }
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        window?.makeKeyAndVisible()
    }

    private func stubResponses() {
        stub(condition: { $0.url?.absoluteString.hasSuffix("v1/shareholders") ?? false }, response: "Shareholders.json")

        (1 ... 3).forEach { index in
            let path = index * 10 + index
            stub(condition: {
                $0.url?.absoluteString.hasSuffix("v1/shareholders/\(path)/card") ?? false
            }, response: "ShareholderCard\(path).json")
        }
    }
}

@discardableResult
public func stub(
    condition: @escaping HTTPStubsTestBlock,
    response: String,
    headers: [String: Any] = ["Content-Type": "application/json"],
    bundle: Bundle = Bundle.main
) -> HTTPStubsDescriptor {
    guard let filePath = OHPathForFileInBundle(response, bundle)
    else { fatalError("filePath for UITest budle not found") }

    let response: HTTPStubsResponseBlock = { _ in
        HTTPStubsResponse(fileAtPath: filePath, statusCode: 200, headers: headers)
    }
    return HTTPStubs.stubRequests(passingTest: condition, withStubResponse: response)
}
