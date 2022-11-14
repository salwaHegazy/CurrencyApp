//
//  AvailableCurrenciesModel.swift
//  CurrencyApp
//
//  Created by Salwa Hegazy on 13/11/2022.
//

import Foundation

// MARK: - AvailableCurrenciesModel
struct AvailableCurrenciesModel: Codable {
    let success: Bool
    let symbols: Symbols
}

// MARK: - Symbols
struct Symbols: Codable {
    let aed, afn, all, amd: String

    enum CodingKeys: String, CodingKey {
        case aed = "AED"
        case afn = "AFN"
        case all = "ALL"
        case amd = "AMD"
    }
}
