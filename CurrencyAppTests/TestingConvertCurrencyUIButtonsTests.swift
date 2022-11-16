//
//  TestingConvertCurrencyUIButtonsTests.swift
//  CurrencyAppTests
//
//  Created by Salwa Hegazy on 16/11/2022.
//

import XCTest
@testable import CurrencyApp

class TestingConvertCurrencyUIButtonsTests: XCTestCase {

    var sut : ConvertCurrencyViewController!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "ConvertCurrency", bundle: nil)
        
        sut = storyboard.instantiateViewController(withIdentifier: "ConvertCurrencyViewController") as? ConvertCurrencyViewController
        
        sut.loadViewIfNeeded()
    }
    
    func testIfSwapButtonHasActionAssigned() {
        let swapButton: UIButton = sut.swapButton
        
        guard let swapButtonActions = swapButton.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail("UIButton does not have actions assigned for Control Event .touchUpInside")
            return
        }
        XCTAssertTrue(swapButtonActions.contains("swapBtnPressed:"))
    }
    
    func testIfDetailsButtonHasActionAssigned() {
        let detailsButton: UIButton = sut.detailsButton
        
        guard let detailsButtonActions = detailsButton.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail("UIButton does not have actions assigned for Control Event .touchUpInside")
            return
        }
        XCTAssertTrue(detailsButtonActions.contains("detailsBtnPressed:"))
    }

    override func tearDownWithError() throws {
        sut = nil
    }

}
