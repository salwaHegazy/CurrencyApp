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
    
    private var historicalModelSubject = PublishSubject<[String]>()
    
    var branchesModelObservable: Observable<[String]> {
        return historicalModelSubject
    }
    
    //MARK: - Methods
    
    func getHistoricalData() {
        
    }
    
}
