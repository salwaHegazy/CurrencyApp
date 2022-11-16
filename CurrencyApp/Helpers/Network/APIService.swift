//
//  APIService.swift
//  CurrencyApp
//
//  Created by Salwa Hegazy on 13/11/2022.
//

import Foundation
import Alamofire


protocol APIServiceProtocol {
    var isGetDataCalled:Bool {get set}
    func getData<T: Decodable, E: Decodable>(endPoint: Endpoint, method: HTTPMethod ,params: Parameters?, encoding: ParameterEncoding,headers: HTTPHeaders?,completion: @escaping (T?, E?, Error?)->())
}

enum APIEnvironment {
    case development
    case production
}

class APIService :  APIServiceProtocol {
    
    var isGetDataCalled: Bool = false
    private var apiEnvironment : APIEnvironment
    
    init (apiEnvironment : APIEnvironment) {
        self.apiEnvironment = apiEnvironment
    }
    
    func getData<T: Decodable, E: Decodable>(endPoint: Endpoint, method: HTTPMethod ,params: Parameters? = nil, encoding: ParameterEncoding = JSONEncoding.default ,headers: HTTPHeaders? = nil ,completion: @escaping (T?, E?, Error?)->()) {
        
        guard let url = URL(string: endPoint.path) else {return}
        
        Alamofire.request(url, method: method, parameters: params, encoding: encoding, headers: headers)
            .validate(statusCode: 200...300)
            .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    guard let data = response.data else { return }
                    do {
                        let jsonData = try JSONDecoder().decode(T.self, from: data)
                        completion(jsonData, nil, nil)
                    } catch let jsonError {
                        print(jsonError)
                    }
                    
                case .failure(let error):
                    // switch on Error Status Code
                    guard let data = response.data else { return }
                    guard let statusCode = response.response?.statusCode else { return }
                    switch statusCode {
                    case 400..<500:
                        do {
                            let jsonError = try JSONDecoder().decode(E.self, from: data)
                            completion(nil, jsonError, nil)
                        } catch let jsonError {
                            print(jsonError)
                        }
                    default:
                        completion(nil, nil, error)
                    }
                }
        }
    }
}

