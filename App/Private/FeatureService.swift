import SharedProtocolsAndModels

final class FeatureService: FeaturesServiceProtocol {
    func updateFeature(_ name: SharedProtocolsAndModels.AnyFeature, enabled: Bool, updateCache: Bool) { }
    
    func enabled(_ name: SharedProtocolsAndModels.AnyFeature) -> Bool {
        return features(nil).contains(name)
    }
    
    func getFeatures(_ completion: @escaping (Error?) -> Void) {
        completion(nil)
    }
    
    func features(_ filter: SharedProtocolsAndModels.FeaturesFilter?) -> Set<SharedProtocolsAndModels.AnyFeature> {
        return AnyFeature.allCases
    }
    
    private init() { }
    
    static let shared: FeaturesServiceProtocol = FeatureService()
}
