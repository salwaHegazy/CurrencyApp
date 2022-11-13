//
//  BaseErrorModel.swift
//  CurrencyApp
//
//  Created by Salwa Hegazy on 13/11/2022.
//

import Foundation

// MARK: - BaseErrorModel
struct BaseErrorModel: Codable {
    let success: Bool
    let error: BaseError
}

// MARK: - Error
struct BaseError: Codable {
    let code: Int
    let type, info: String
}
