//
//  ConvertCurrencyViewModel.swift
//  CurrencyApp
//
//  Created by Salwa Hegazy on 13/11/2022.
//

import Foundation
import RxCocoa
import RxSwift

class ConvertCurrencyViewModel {
    
    //MARK: - Members
    private var currenciesModelSubject = PublishSubject<[String]>()
    private var convertedAmountSubject = PublishSubject<String>()
    
    var fromCurrencyBehavior = BehaviorRelay<String>(value: "")
    var toCurrencyBehavior = BehaviorRelay<String>(value: "")
    var amountToConvertBehavior = BehaviorRelay<String>(value: "")
    var loadingBehavior = BehaviorRelay<Bool>(value: false)

    var currenciesModelObservable: Observable<[String]> {
        return currenciesModelSubject
    }
    
    var convertedAmountObservable: Observable<String> {
        return convertedAmountSubject
    }
    
    //MARK: - Methods
    func getAvailableCurrencies() {
        let headers = [
            "apikey" : "sqQqQKqoyXF50INsC7kSJV2lNgTxfYTp"
        ]
        
        print(headers)

        APIService.instance.getData(endPoint: URLPath.getAvailableCurrenciesSymbols, method: .get, headers: headers ) { [weak self] (currenciesModel: AvailableCurrenciesModel?, errorModel: BaseErrorModel?, error) in
            guard let self = self else { return }
            
            if let error = error {
                
                print(error.localizedDescription)
                
            } else if let errorModel = errorModel {
                
                print(errorModel.error.info)
                
            } else {
                guard let currencies = currenciesModel?.symbols else { return }
                
                if currencies.count > 0 {
                    self.currenciesModelSubject.onNext(currencies.keys.map({$0}))
                } else {
                    
                }
            }

        }
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
        
        APIService.instance.getData(endPoint: URLPath.convertCurrency, method: .get, params: params, headers: headers) { [weak self] (convertModel: ConvertModel?, errorModel: BaseErrorModel?, error) in
            guard let self = self else { return }
            self.loadingBehavior.accept(false)
            
            if let error = error {
                
                print(error.localizedDescription)
                
            } else if let errorModel = errorModel {
                
                print(errorModel.error.info)
                
            } else {
                
                guard let convertModel = convertModel else { return }
                if convertModel.success {
                    self.convertedAmountSubject.onNext(String(convertModel.result))
                } else {
                    print("Failed to Convert Amount..")
                }
            }
        }

    }
    
}
