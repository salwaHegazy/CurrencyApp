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

class DetailsViewModel {
    
    //MARK: - Members
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    var showAlertBehavior = BehaviorRelay<String>(value: "")
    
    private var historicalDataModelSubject = PublishSubject<[String]>()
    
    var historicalDataModelObservable: Observable<[String]> {
        return historicalDataModelSubject
    }
    
    //MARK: - Methods
    func getHistoricalData() {
        let decoder = JSONDecoder()
        if let currenciesFileUrl  = Bundle.main.url(forResource: "historical_data", withExtension: "json"),
           let data = try? Data.init(contentsOf: currenciesFileUrl),
           let historicalDataModel = try? decoder.decode(HistoricalRatesModel.self, from: data){
            guard let rates = historicalDataModel.rates else { return }
            print(rates)
            if rates.count > 0 {
                self.historicalDataModelSubject.onNext(rates.keys.map({$0}))
            } else {
                self.showAlertBehavior.accept("There is no data..")
            }
        }
    }
    
}
