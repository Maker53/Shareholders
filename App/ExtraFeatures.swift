import AlfaFoundation
import Shareholders

enum ExtraFeatures {
    static func setup() {
        AnyFeature.register { container in
            container.add(ShareholdersFeature.self)
        }
    }
}
