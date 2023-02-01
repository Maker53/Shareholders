//  Created by Dmitry Polyakov on 18/10/2019.

import ABUIComponents
import Nuke
import SharedProtocolsAndModels

protocol ImagePipelineProtocol {
    @discardableResult
    func loadImage(
        with request: Nuke.ImageRequestConvertible, queue: DispatchQueue?, completion: @escaping Nuke.ImageTask.Completion
    ) -> AnyObject
}

extension ImagePipelineProtocol {
    @discardableResult
    func loadImage(with request: Nuke.ImageRequestConvertible, completion: @escaping Nuke.ImageTask.Completion) -> AnyObject {
        loadImage(with: request, queue: nil, completion: completion)
    }
}

// MARK: - ImagePipeline + ImagePipelineProtocol

extension ImagePipeline: ImagePipelineProtocol {
    func loadImage(
        with request: ImageRequestConvertible, queue: DispatchQueue?, completion: @escaping ImageTask.Completion
    ) -> AnyObject {
        let imageTask: ImageTask = loadImage(with: request, queue: queue, completion: completion)
        return imageTask
    }
}

final class NukeImageLoader: LoadsImages {
    typealias CancelLoading = (ImageDisplayingView) -> Void
    typealias LoadImage = (
        URLRequest,
        ImageLoadingOptions,
        ImageDisplayingView,
        ImageTask.ProgressHandler?,
        ImageTask.Completion?
    ) -> ImageTask?

    private let cancelLoading: CancelLoading
    private let imagePipeline: ImagePipelineProtocol
    private let loadImage: LoadImage

    init(
        cancelLoading: @escaping CancelLoading = Nuke.cancelRequest,
        imagePipeline: ImagePipelineProtocol = ImagePipeline.shared,
        loadImage: @escaping LoadImage = Nuke.loadImage
    ) {
        self.cancelLoading = cancelLoading
        self.imagePipeline = imagePipeline
        self.loadImage = loadImage
        ImagePipeline.shared = ImagePipeline {
            let dataCache = try? DataCache(name: Configuration.dataCacheName)
            dataCache?.sizeLimit = Configuration.diskCapacity
            $0.dataCache = dataCache
            #if DEBUG
            $0.dataLoader = TrustedDataLoader()
            #else
            let configuration = DataLoader.defaultConfiguration
            configuration.urlCache = nil
            $0.dataLoader = DataLoader(configuration: configuration, validate: DataLoader.validate)
            #endif
        }
    }

    func load(with arguments: ImageLoadingArguments) {
        let imageOptions = ImageLoadingOptions(
            placeholder: arguments.placeholder,
            transition: getNukeAnimation(by: arguments.animation),
            contentModes: getNukeContentModes(arguments.options?.contentModes),
            tintColors: getNukeTintColors(arguments.options?.tintColors)
        )
        _ = loadImage(arguments.urlRequest, imageOptions, arguments.imageView, nil) { result in
            let success = try? result.get()
            arguments.completion?(success?.image)
        }
    }

    func load(with url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        imagePipeline.loadImage(with: url) {
            switch $0 {
            case let .success(imageResponse):
                completion(.success(imageResponse.image))
            case let .failure(imagePipelineError):
                switch imagePipelineError {
                case let .dataLoadingFailed(error):
                    completion(.failure(error))
                default:
                    completion(.failure(NSError()))
                }
            }
        }
    }

    func cancel(for imageView: UIImageView) {
        cancelLoading(imageView)
    }
}

private extension NukeImageLoader {
    typealias NukeAnimation = ImageLoadingOptions.Transition
    typealias NukeContentModes = ImageLoadingOptions.ContentModes
    typealias NukeTintColors = ImageLoadingOptions.TintColors

    func getNukeAnimation(by animation: ImageLoadingAppearanceAnimation?) -> NukeAnimation? {
        guard let animation = animation else { return nil }
        switch animation {
        case let .fadeIn(duration):
            return .fadeIn(duration: duration)
        }
    }

    func getNukeContentModes(_ contentModes: ContentModes?) -> NukeContentModes? {
        guard let contentModes = contentModes else { return nil }
        return NukeContentModes(
            success: contentModes.success,
            failure: contentModes.failure,
            placeholder: contentModes.placeholder
        )
    }

    func getNukeTintColors(_ tintColors: TintColors?) -> NukeTintColors? {
        guard let tintColors = tintColors else { return nil }
        return NukeTintColors(
            success: tintColors.success,
            failure: tintColors.failure,
            placeholder: tintColors.placeholder
        )
    }
}

extension NukeImageLoader {
    enum Configuration {
        static let diskCapacity = 1_024 * 1_024 * 100 // 100 Mb
        static let dataCacheName = "alfabank-image-data-cache"
    }
}
