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
    let rates: [String: Double]?
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

