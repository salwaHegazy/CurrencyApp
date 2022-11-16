//
//  MockApiService.swift
//  CurrencyAppTests
//
//  Created by Salwa Hegazy on 16/11/2022.
//

import Foundation
@testable import CurrencyApp
import Alamofire

class MockApiService: APIServiceProtocol {
    
    var isGetDataCalled = false
    
    func getData<T: Decodable, E: Decodable>(endPoint: Endpoint, method: HTTPMethod ,params: Parameters? = nil, encoding: ParameterEncoding = JSONEncoding.default ,headers: HTTPHeaders? = nil ,completion: @escaping (T?, E?, Error?)->())  {
        
        isGetDataCalled = true
    }
    
}
