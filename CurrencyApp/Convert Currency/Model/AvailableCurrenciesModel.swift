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
    let symbols: [String: String]?
}
