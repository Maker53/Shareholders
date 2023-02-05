// Created by Станислав on 05.02.2023.

import SharedProtocolsAndModels

struct Shareholder: Decodable {
    let id: String
    let iconURL: String
    let name: String
    let company: String
    let amount: Amount
    let profit: Double
}
