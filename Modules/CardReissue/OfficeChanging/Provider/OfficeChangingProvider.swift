///  Created by Roman Turov on 15/04/2019.

import AlfaNetworking
import NetworkKit
import SharedServices

public protocol ProvidesBankOffices {
    func getCities() -> Promise<[City]>
    func getMetro(in city: City) -> Promise<[Metro]>
    func getOffice(in city: City, nearBy metro: Metro?) -> Promise<[Office]>
    func invalidateCache()
    func invalidateOfficesCache()
}

public class OfficeChangingProvider: ProvidesBankOffices {
    private let cityService: ModelService<[City]>
    private let metroService: ParameterizedModelService<[Metro], MetroServiceParameters>
    private let officeService: ParameterizedModelService<[Office], OfficeServiceParameters>
    private let dataStore: OfficeChangingDataStore

    public init(
        cityService: ModelService<[City]> = .init(CityService()),
        metroService: ParameterizedModelService<[Metro], MetroServiceParameters> = .init(MetroService()),
        officeService: ParameterizedModelService<[Office], OfficeServiceParameters> = .init(OfficeService()),
        dataStore: OfficeChangingDataStore = OfficeChangingDataStore()
    ) {
        self.cityService = cityService
        self.metroService = metroService
        self.officeService = officeService
        self.dataStore = dataStore
    }

    public func getCities() -> Promise<[City]> {
        if dataStore.cities.isNotEmpty {
            return .value(dataStore.cities)
        }
        return cityService.sendRequest()
            .get { [weak self] in
                self?.dataStore.cities = $0
            }
    }

    public func getMetro(in city: City) -> Promise<[Metro]> {
        if dataStore.metro.isNotEmpty {
            return .value(dataStore.metro)
        }
        return metroService.sendRequest(parameters: .init(uid: city.uid))
            .get { [weak self] in
                self?.dataStore.metro = $0
            }
    }

    public func getOffice(in city: City, nearBy metro: Metro?) -> Promise<[Office]> {
        if dataStore.offices.isNotEmpty {
            return .value(dataStore.offices)
        }
        return officeService.sendRequest(parameters: .init(city: city.uid, metro: metro?.uid))
            .get { [weak self] in
                self?.dataStore.offices = $0
            }
    }

    public func invalidateCache() {
        dataStore.purge()
    }

    public func invalidateOfficesCache() {
        dataStore.offices = []
    }
}

extension OfficeChangingProvider {
    enum ParamKeys: String {
        case city
        case metro
    }
}

public typealias CityService = DecodableSimpleService<Void, Void, [City], ServiceError>

public extension CityService {
    convenience init() {
        self.init(endpoint: "office/city")
    }
}

public typealias MetroService = CodableSimpleService<MetroServiceParameters, Void, [Metro], ServiceError>

public struct MetroServiceParameters: Encodable {
    let uid: UniqueIdentifier
}

public extension MetroService {
    convenience init() {
        self.init(endpoint: "office/metro")
    }
}

public struct OfficeServiceParameters: Encodable {
    let city: UniqueIdentifier
    let metro: UniqueIdentifier?

    private let kind = "retailnotvipp"
}

public typealias OfficeService = CodableSimpleService<OfficeServiceParameters, Void, [Office], ServiceError>

public extension OfficeService {
    convenience init() {
        self.init(endpoint: "office/list")
    }
}
