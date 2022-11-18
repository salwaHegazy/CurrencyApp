//
//  ConvertCurrencyTests.swift
//  CurrencyAppTests
//
//  Created by Salwa Hegazy on 15/11/2022.
//

import XCTest
@testable import CurrencyApp

class ConvertCurrencyTests: XCTestCase {
    
    var sut : ConvertCurrencyViewController!

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "ConvertCurrency", bundle: nil)
        
        sut = storyboard.instantiateViewController(withIdentifier: "ConvertCurrencyViewController") as? ConvertCurrencyViewController
        
        sut.loadViewIfNeeded()
    }
     
    func testSetUpFromDropDownListData() throws {
        let currencies = ["AED" , "USD" , "EGP" ,"SAR"]
        sut.setUpDropDownListsDataSource(currencies)
        XCTAssertEqual(sut.fromDropDown.dataSource, currencies)
    }

    func testSetUpToDropDownListData() throws {
        let currencies = ["USD" , "EGP" ]
        sut.setUpDropDownListsDataSource(currencies)
        XCTAssertEqual(sut.toDropDown.dataSource, currencies)
    }
   /*
    func testSwapCurrencies() throws {
        sut.swapCurrencies(fromTextFieldTxt: "USD", toTextFieldTxt: "EGP", amountTextFieldTxt: "1", convertedAmountTextFieldTxt: "24.48")
        XCTAssertEqual(sut.fromSelectedTextField.text, "EGP")
        XCTAssertEqual(sut.toSelectedTextField.text, "USD")
        XCTAssertEqual(sut.amountTextField.text, "24.48")
        XCTAssertEqual(sut.convertedAmountTextField.text, "1")
    }
    */
    
    override func tearDownWithError() throws {
        sut = nil
    }

}
