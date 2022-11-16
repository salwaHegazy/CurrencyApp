//
//  ConvertCurrencyViewModel.swift
//  CurrencyApp
//
//  Created by Salwa Hegazy on 13/11/2022.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

class ConvertCurrencyViewModel {
    
    //MARK: - Members
    private var currenciesModelSubject = PublishSubject<[String]>()
    private var convertedAmountSubject = PublishSubject<String>()
    
    var fromCurrencyBehavior = BehaviorRelay<String>(value: "")
    var toCurrencyBehavior = BehaviorRelay<String>(value: "")
    var amountToConvertBehavior = BehaviorRelay<String>(value: "")
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    var showAlertBehavior = BehaviorRelay<String>(value: "")

    var currenciesModelObservable: Observable<[String]> {
        return currenciesModelSubject
    }
    
    var convertedAmountObservable: Observable<String> {
        return convertedAmountSubject
    }
    
    let apiService : APIServiceProtocol
    
    init( apiService: APIServiceProtocol = APIService(apiEnvironment: .development)) {
        self.apiService = apiService
    }
    
    //MARK: - Methods
    func getAvailableCurrencies() {
        let decoder = JSONDecoder()
        if let currenciesFileUrl  = Bundle.main.url(forResource: "currencies_list", withExtension: "json"),
           let data = try? Data.init(contentsOf: currenciesFileUrl),
           let currenciesModel = try? decoder.decode(AvailableCurrenciesModel.self, from: data){
            guard let currencies = currenciesModel.symbols else { return }
            
            if currencies.count > 0 {
                self.currenciesModelSubject.onNext(currencies.keys.map({$0}))
            } else {
                self.showAlertBehavior.accept("There is no data..")
            }
        }
/*
        let headers = [
            "apikey" : "sqQqQKqoyXF50INsC7kSJV2lNgTxfYTp"
        ]
 
        apiService.getData(endPoint: URLPath.getAvailableCurrenciesSymbols, method: .get, headers: headers ) { [weak self] (currenciesModel: AvailableCurrenciesModel?, errorModel: BaseErrorModel?, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlertBehavior.accept(error.localizedDescription)
               // print(error.localizedDescription)
                
            } else if let errorModel = errorModel {
                self.showAlertBehavior.accept(errorModel.error?.info ?? "")
               // print(errorModel.error.info)
                
            } else {
                guard let currencies = currenciesModel?.symbols else { return }
                
                if currencies.count > 0 {
                    self.currenciesModelSubject.onNext(currencies.keys.map({$0}))
                } else {
                    self.showAlertBehavior.accept("There is no data..")
                }
            }
        }
 */
    }
    
    func convertCurrency() {
        loadingBehavior.accept(true)
        let params = [
            "to": toCurrencyBehavior.value,
            "from": fromCurrencyBehavior.value,
            "amount": amountToConvertBehavior.value
        ]
        
        let headers = [
            "apikey" : "sqQqQKqoyXF50INsC7kSJV2lNgTxfYTp"
        ]
        
       
        apiService.getData(endPoint: URLPath.convertCurrency, method: .get, params: params, encoding: URLEncoding.queryString,headers: headers) { [weak self] (convertModel: ConvertModel?, errorModel: BaseErrorModel?, error) in
            guard let self = self else { return }
            self.loadingBehavior.accept(false)
            if let error = error {
                self.showAlertBehavior.accept(error.localizedDescription)
               // print(error.localizedDescription)
                
            } else if let errorModel = errorModel {
                self.showAlertBehavior.accept(errorModel.error?.info ?? "")
               // print(errorModel.error.info)
                
            } else {
                guard let convertModel = convertModel else { return }
                guard let result = convertModel.result else { return }
                
                if convertModel.success ?? true {
                    self.convertedAmountSubject.onNext(String(result))
                } else {
                    self.showAlertBehavior.accept("Failed to Convert Amount..")
                }
            }
        }

    }
    
}
