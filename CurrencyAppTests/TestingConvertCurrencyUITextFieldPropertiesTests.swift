//
//  TestingUITextFieldPropertiesTests.swift
//  CurrencyAppTests
//
//  Created by Salwa Hegazy on 16/11/2022.
//

import XCTest
@testable import CurrencyApp

class TestingConvertCurrencyUITextFieldPropertiesTests: XCTestCase {

    var sut : ConvertCurrencyViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let storyboard = UIStoryboard(name: "ConvertCurrency", bundle: nil)
        
        sut = storyboard.instantiateViewController(withIdentifier: ConvertCurrencyViewController.identifier) as? ConvertCurrencyViewController
        
        sut.loadViewIfNeeded()
    }

    func testConvertCurrency_WhenLoaded_TextFieldsAreConnected() throws {
        _ = try XCTUnwrap(sut.fromSelectedTextField, "The FromSelected UITextField is not connected")
        _ = try XCTUnwrap(sut.toSelectedTextField, "The ToSelected UITextField is not connected")
        _ = try XCTUnwrap(sut.amountTextField, "The Amount UITextField is not connected")
        _ = try XCTUnwrap(sut.convertedAmountTextField, "The ConvertedAmount UITextField is not connected")
    }
    
    func testAmountField_WhenCreated_HasNumberPadKeyboardTypeSet() throws {
        let amountTextField = try XCTUnwrap(sut.amountTextField, "The Amount UITextField is not connected")
        
        XCTAssertEqual(amountTextField.keyboardType, UIKeyboardType.numberPad, "The Amount UITextField does not have NumberPad Keyboard type set")
    }
    
    func testConvertedAmountField_WhenCreated_HasNumberPadKeyboardTypeSet() throws {
        let convertedAmountTextField = try XCTUnwrap(sut.amountTextField, "The Converted Amount UITextField is not connected")
        
        XCTAssertEqual(convertedAmountTextField.keyboardType, UIKeyboardType.numberPad, "The Converted Amount UITextField does not have NumberPad Keyboard type set")
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
}
