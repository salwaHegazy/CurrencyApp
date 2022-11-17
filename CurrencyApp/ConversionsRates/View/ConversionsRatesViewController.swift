//
//  ConversionsRatesViewController.swift
//  CurrencyApp
//
//  Created by Salwa Hegazy on 17/11/2022.
//

import UIKit
import RxSwift


class ConversionsRatesViewController: UIViewController {

    //MARK: - Outlets

    //MARK: - Members
    let conversionsRatesViewModel = ConversionsRatesViewModel()
    let disposeBag = DisposeBag()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        subscribeToLoading()
        getHistoricalConversionsRatesData()
    }
    

    //MARK: - Methods
    func setUpNavigationBar() {
        self.title = "Conversions Rates"
    }
    
    func subscribeToLoading() {
        conversionsRatesViewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
            if isLoading {
                self.showIndicator(withTitle: "", and: "")
            } else {
                self.hideIndicator()
            }
        }).disposed(by: disposeBag)
    }
    
    func getHistoricalConversionsRatesData() {
        conversionsRatesViewModel.getHistoricalConversionsRatesData()
    }
    
    
}
