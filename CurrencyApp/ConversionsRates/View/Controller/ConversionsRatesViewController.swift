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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var baseCurrencyNameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var getConversionsRatesButton: UIButton!
    
    //MARK: - Members
    let conversionsRatesTableViewCell = "ConversionsRatesTableViewCell"
    let conversionsRatesViewModel = ConversionsRatesViewModel()
    let disposeBag = DisposeBag()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setupTableView()
        bindBaseCurrencyNameTextFieldToViewModel()
        bindDateTextFieldToViewModel()
        bindToHiddenTable()
        subscribeToLoading()
        subscribeIsGetConversionsRateButtonEnabled()
        subscribeToResponse()
        subscribeToGetConversionsRatesButton()
    }
    
    //MARK: - Methods
    func setUpNavigationBar() {
        self.title = "Conversions Rates"
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: conversionsRatesTableViewCell, bundle: nil), forCellReuseIdentifier: conversionsRatesTableViewCell)
    }

    func bindBaseCurrencyNameTextFieldToViewModel() {
        baseCurrencyNameTextField.rx.text.orEmpty.bind(to: conversionsRatesViewModel.baseCurrencyNameBehavior).disposed(by: disposeBag)
    }
    
    func bindDateTextFieldToViewModel() {
        dateTextField.rx.text.orEmpty.bind(to: conversionsRatesViewModel.dateBehavior).disposed(by: disposeBag)
    }
    
    func bindToHiddenTable() {
        conversionsRatesViewModel.isTableHiddenObservable.bind(to: containerView.rx.isHidden).disposed(by: disposeBag)
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
    
    func subscribeToResponse() {
        conversionsRatesViewModel.historicalConversionsRatesObservable
            .bind(to: self.tableView
                .rx
                .items(cellIdentifier: conversionsRatesTableViewCell,
                       cellType: ConversionsRatesTableViewCell.self)) { row, currencyRates, cell in
                cell.configCell(data: currencyRates)
        }
        .disposed(by: disposeBag)
    }
    
    func subscribeIsGetConversionsRateButtonEnabled() {
        conversionsRatesViewModel.isGetConversionsRatesEnabled.bind(to: getConversionsRatesButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    func subscribeToGetConversionsRatesButton() {
        getConversionsRatesButton.rx.tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self](_) in
                guard let self = self else { return }
                self.conversionsRatesViewModel.getHistoricalConversionsRatesData()
        }).disposed(by: disposeBag)
    }
    
    func subscribeToShowAlert() {
        conversionsRatesViewModel.showAlertBehavior.subscribe(onNext: { [weak self] message in
           guard let self = self else { return }
            self.showAlert(withTitle: "Alert" , andMessage: message)
        }).disposed(by: disposeBag)
    }
    
    func getHistoricalConversionsRatesData() {
        conversionsRatesViewModel.getHistoricalConversionsRatesData()
    }
}
