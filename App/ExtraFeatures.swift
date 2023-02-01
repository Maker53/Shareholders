import AlfaFoundation

enum ExtraFeatures {
    static func setup() {
        AnyFeature.register { _ in }
    }
}
