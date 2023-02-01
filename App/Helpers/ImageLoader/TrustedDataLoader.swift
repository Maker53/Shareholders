//  Created by Dmitry Polyakov on 12/11/2019.

import Alamofire
import Nuke

final class TrustedDataLoader: Nuke.DataLoading {
    private let manager: Alamofire.Session

    init(
        manager: Alamofire.Session = Alamofire.Session(
            configuration: URLSessionConfiguration.defaultWithoutCache,
            delegate: SessionDelegate(fileManager: .default),
            serverTrustManager: ServerTrustManager(
                allHostsMustBeEvaluated: false,
                evaluators: Configuration.servertTrustEvaluators
            )
        )
    ) {
        self.manager = manager
    }

    func loadData(
        with request: URLRequest,
        didReceiveData: @escaping (Data, URLResponse) -> Void,
        completion: @escaping (Error?) -> Void
    ) -> Cancellable {
        let task = manager.streamRequest(request)
        task.responseStream { [weak task] stream in
            switch stream.event {
            case let .stream(result):
                switch result {
                case let .success(data):
                    guard let response = task?.response else { return }
                    didReceiveData(data, response)
                }
            case let .complete(response):
                completion(response.error)
            @unknown default:
                fatalError("Unreachable case")
            }
        }
        return AnyCancellable {
            task.cancel()
        }
    }
}

extension TrustedDataLoader {
    enum Configuration {
        static let servertTrustEvaluators: [String: ServerTrustEvaluating] = [
            "testsense.alfabank.ru": DisabledTrustEvaluator(),
        ]
    }
}

private extension URLSessionConfiguration {
    static var defaultWithoutCache: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.urlCache = nil
        return configuration
    }
}

private final class AnyCancellable: Nuke.Cancellable {
    let closure: () -> Void

    init(_ closure: @escaping () -> Void) {
        self.closure = closure
    }

    func cancel() {
        closure()
    }
}
