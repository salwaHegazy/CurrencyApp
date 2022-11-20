//
//  TestingConversionsRatesUITextFieldPropertiesTests.swift
//  CurrencyAppTests
//
//  Created by Salwa Hegazy on 19/11/2022.
//

import XCTest
@testable import CurrencyApp

class TestingConversionsRatesUITextFieldPropertiesTests: XCTestCase {
   
    var sut : ConversionsRatesViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let storyboard = UIStoryboard(name: "ConvertCurrency", bundle: nil)
        
        sut = storyboard.instantiateViewController(withIdentifier: ConversionsRatesViewController.identifier) as? ConversionsRatesViewController
        
        sut.loadViewIfNeeded()
    }
    
    func testConversionsRates_WhenLoaded_TextFieldsAreConnected() throws {
        _ = try XCTUnwrap(sut.dateTextField, "The Date UITextField is not connected")
        _ = try XCTUnwrap(sut.baseCurrencyNameTextField, "The BaseCurrencyName UITextField is not connected")
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

}
