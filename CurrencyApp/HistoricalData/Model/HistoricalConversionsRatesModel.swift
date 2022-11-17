//
//  HistoricalConversionRatesModel.swift
//  CurrencyApp
//
//  Created by Salwa Hegazy on 17/11/2022.
//

import Foundation

// MARK: - HistoricalConversionsRatesModel
struct HistoricalConversionsRatesModel: Codable {
    let base, date: String
    let historical: Bool
    let rates: [String: Double]?
    let success: Bool
    let timestamp: Int
}


