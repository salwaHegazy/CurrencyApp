//
//  NetworkTests.swift
//  CurrencyAppNetworkTests
//
//  Created by Salwa Hegazy on 20/11/2022.
//

import XCTest
@testable import CurrencyApp

class NetworkTests: XCTestCase {
    var sut: URLSession!
    let networkMonitor = NetworkMonitor.shared

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testApiRequestCompeletes() throws {
      try XCTSkipUnless(
        networkMonitor.isReachable,
        "Network connection needed..."
      )

      let url = URL(string: "https://api.apilayer.com/fixer/symbols")!
      let promise = expectation(description: "Completion handler invoked...")
      var statusCode: Int?
      var requestError: Error?

      let dataTask = sut.dataTask(with: url) { _, response, error in
        statusCode = (response as? HTTPURLResponse)?.statusCode
        requestError = error
        promise.fulfill()
      }
        
      dataTask.resume()
      wait(for: [promise], timeout: 5)

      XCTAssertNil(requestError)
      XCTAssertEqual(statusCode, 200)
    }
    
}
