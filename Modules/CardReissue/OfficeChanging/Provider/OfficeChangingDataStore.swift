///
///  Created by Roman Turov on 15/04/2019.
///

import AMSharedProtocolsAndModels

/// Класс для хранения данных модуля OfficeChanging
public class OfficeChangingDataStore: Purgeable {
    public var cities: [City] = []
    public var metro: [Metro] = []
    public var offices: [Office] = []

    public init() { }

    public func purge() {
        metro = []
        offices = []
    }
}
