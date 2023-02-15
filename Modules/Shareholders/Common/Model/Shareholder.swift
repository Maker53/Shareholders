// Created by Станислав on 05.02.2023.

import SharedProtocolsAndModels

struct Shareholder: Decodable, Equatable {
    let id: String
    let iconURL: String
    let name: String
    let company: Company
    let amount: Amount
    let profit: Double
}

enum Company: String, Decodable {
    case Tinek, Alfabank, Sber
    case unknown
    
    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
