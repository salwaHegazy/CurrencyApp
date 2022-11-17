//
//  HistoricalRatesModel.swift
//  CurrencyApp
//
//  Created by Salwa Hegazy on 16/11/2022.
//

import Foundation

// MARK: - HistoricalRatesModel
struct HistoricalRatesModel: Codable {
    let base, endDate: String
    let rates: [String: Rate]
    let startDate: String
    let success, timeseries: Bool

    enum CodingKeys: String, CodingKey {
        case base
        case endDate = "end_date"
        case rates
        case startDate = "start_date"
        case success, timeseries
    }
}

// MARK: - Rate
struct Rate: Codable {
    let aud, cad, usd: Double

    enum CodingKeys: String, CodingKey {
        case aud = "AUD"
        case cad = "CAD"
        case usd = "USD"
    }
    
}

