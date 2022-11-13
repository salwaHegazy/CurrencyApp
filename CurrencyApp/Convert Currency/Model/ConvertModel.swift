//
//  ConvertCurrencyModel.swift
//  CurrencyApp
//
//  Created by Salwa Hegazy on 13/11/2022.
//

import Foundation

// MARK: - ConvertModel
struct ConvertModel: Codable {
    let success: Bool
    let query: Query
    let info: Info
    let historical: String?
    let date: String
    let result: Double
}

// MARK: - Info
struct Info: Codable {
    let timestamp: Int
    let rate: Double
}

// MARK: - Query
struct Query: Codable {
    let from, to: String
    let amount: Int
}
