//
//  NConstants.swift
//  CurrencyApp
//
//  Created by Salwa Hegazy on 13/11/2022.
//

import Foundation

// MARK: - Paths Handling

protocol Endpoint {
    var path: String { get }
}

enum URLPath {
    case getAvailableCurrenciesSymbols
    case convertCurrency
}

extension URLPath: Endpoint {
    var path: String {
        switch self {
        case .getAvailableCurrenciesSymbols : return fullURL("https://api.apilayer.com/fixer/symbols")
        case .convertCurrency : return fullURL("https://api.apilayer.com/fixer/convert")
        
        }
    }
}

private func fullURL(_ path: String) -> String {
    return path
}
