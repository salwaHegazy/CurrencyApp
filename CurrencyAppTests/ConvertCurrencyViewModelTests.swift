//
//  ConvertCurrencyViewModelTests.swift
//  CurrencyAppTests
//
//  Created by Salwa Hegazy on 16/11/2022.
//

import XCTest
@testable import CurrencyApp

class ConvertCurrencyViewModelTests: XCTestCase {
    
    var sut : ConvertCurrencyViewModel!
    var mockAPIService : APIServiceProtocol!
    
    override func setUpWithError() throws {
        mockAPIService = MockApiService()
        sut = ConvertCurrencyViewModel(apiService: mockAPIService)
    }
    
    func testConvertCurrencyCalledApiService() throws {
        sut.convertCurrency()
        XCTAssertTrue(mockAPIService.isGetDataCalled)
    }
    
    func testGetAvailableCurrencies() throws {
        sut.getAvailableCurrencies()
        XCTAssertNotNil(sut.currenciesModelObservable)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockAPIService = nil
    }

}
