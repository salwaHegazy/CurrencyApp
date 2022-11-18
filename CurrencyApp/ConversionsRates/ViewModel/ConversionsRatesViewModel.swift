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
    
    var baseCurrencyNameBehavior = BehaviorRelay<String>(value: "")
    var dateBehavior = BehaviorRelay<String>(value: "")
    
    private var isTableHidden = BehaviorRelay<Bool>(value: false)
    private var historicalConversionsRatesSubject = PublishSubject<[CurrencyRateModel]>()

    var historicalConversionsRatesObservable: Observable<[CurrencyRateModel]> {
        return historicalConversionsRatesSubject
    }
    
    var isTableHiddenObservable: Observable<Bool> {
        return isTableHidden.asObservable()
    }
    
    var isDateValid: Observable<Bool> {
        return dateBehavior.asObservable().map {(date) -> Bool in
            let isDateEmpty = date.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            return isDateEmpty
        }
    }
    
    var isCurrencyValid: Observable<Bool> {
        return baseCurrencyNameBehavior.asObservable().map {(currency) -> Bool in
            let isCurrencyEmpty = currency.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            return isCurrencyEmpty
        }
    }
    
    var isGetConversionsRatesEnabled: Observable<Bool> {
        return Observable.combineLatest(isDateValid , isCurrencyValid) { (isDateEmpty ,isCurrencyEmpty) in
            let GetConversionsRatesValid = !isDateEmpty
            return GetConversionsRatesValid
        }
    }
    
    
    //MARK: - Methods
    func getHistoricalConversionsRatesData() {
        loadingBehavior.accept(true)
       /*
        let params = [
            "base": baseCurrencyNameBehavior.value
        ]
       */
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
                self.isTableHidden.accept(false)
            } else {
                self.showAlertBehavior.accept("There is no data..")
                self.isTableHidden.accept(true)
            }
        }
    }
}
