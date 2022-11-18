//
//  DetailsViewModel.swift
//  CurrencyApp
//
//  Created by Salwa Hegazy on 14/11/2022.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

class HistoricalDataViewModel {
    
    //MARK: - Members
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    var showAlertBehavior = BehaviorRelay<String>(value: "")
    
    private var isTableHidden = BehaviorRelay<Bool>(value: false)
    private var historicalDataModelSubject = PublishSubject<[CurrencyModel]>()
    
    var historicalDataModelObservable: Observable<[CurrencyModel]> {
        return historicalDataModelSubject
    }
    
    var isTableHiddenObservable: Observable<Bool> {
        return isTableHidden.asObservable()
    }
    
    //MARK: - Methods
    func getHistoricalData() {
        loadingBehavior.accept(true)
        let decoder = JSONDecoder()
        if let historicalDataFileUrl  = Bundle.main.url(forResource: "historical_data", withExtension: "json"),
           let data = try? Data.init(contentsOf: historicalDataFileUrl),
           let historicalDataModel = try? decoder.decode(HistoricalRatesModel.self, from: data){
            self.loadingBehavior.accept(false)
            let historicalRates = historicalDataModel.rates
            if historicalRates.count > 0 {
                var currenciesRates = [CurrencyModel]()
                for (key, value) in historicalRates {
                    let currency = CurrencyModel(currencyName: key, rate: value)
                    currenciesRates.append(currency)
                }
                self.historicalDataModelSubject.onNext(currenciesRates)
                self.isTableHidden.accept(false)
            } else {
                self.showAlertBehavior.accept("There is no data..")
                self.isTableHidden.accept(true)
            }
        }
    }
}
