//
//  ConversionsRatesViewModel.swift
//  CurrencyApp
//
//  Created by Salwa Hegazy on 17/11/2022.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

class ConversionsRatesViewModel {
    //MARK: - Members
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    var showAlertBehavior = BehaviorRelay<String>(value: "")
    
    private var historicalConversionsRatesSubject = PublishSubject<[CurrencyRateModel]>()

    var historicalConversionsRatesObservable: Observable<[CurrencyRateModel]> {
        return historicalConversionsRatesSubject
    }
    
    //MARK: - Methods
    func getHistoricalConversionsRatesData() {
        loadingBehavior.accept(true)
        let decoder = JSONDecoder()
        if let historicalConversionsRatesFileUrl  = Bundle.main.url(forResource: "Historical_ConversionsRates", withExtension: "json"),
           let data = try? Data.init(contentsOf: historicalConversionsRatesFileUrl),
           let historicalConversionsRatesModel = try? decoder.decode(HistoricalConversionsRatesModel.self, from: data){
            self.loadingBehavior.accept(false)
            guard let rates = historicalConversionsRatesModel.rates else { return }
            if rates.count > 0 {
                var ConversionsRates = [CurrencyRateModel]()
                for (key, value) in rates {
                    let currencyRate = CurrencyRateModel(currencyName: key, rate: value)
                    ConversionsRates.append(currencyRate)
                }
                self.historicalConversionsRatesSubject.onNext(ConversionsRates)
            } else {
                self.showAlertBehavior.accept("There is no data..")
            }
        }
    }
}
