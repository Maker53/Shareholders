// Created by Станислав on 24.02.2023.

import SharedProtocolsAndModels

@frozen
public enum ShareholdersFeature: String, FeatureFlag {
    // Swap the name of the shareholder and the company
    case swapShareholderAndCompanyName
}
