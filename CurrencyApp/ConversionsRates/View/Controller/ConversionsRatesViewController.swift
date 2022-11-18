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
    
    private lazy var datePicker: UIDatePicker = {
      let datePicker = UIDatePicker(frame: .zero)
      datePicker.datePickerMode = .date
      datePicker.timeZone = TimeZone.current
      datePicker.preferredDatePickerStyle = .inline
      return datePicker
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setupTableView()
        setupTextFields()
        bindBaseCurrencyNameTextFieldToViewModel()
        bindDateTextFieldToViewModel()
        bindToHiddenTable()
        subscribeToLoading()
        subscribeIsGetConversionsRateButtonEnabled()
        subscribeToResponse()
        subscribeToGetConversionsRatesButton()
        hideKeyboardWhenTappedAround()
    }
    
    //MARK: - Methods
    func setUpNavigationBar() {
        self.title = "Conversions Rates"
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: conversionsRatesTableViewCell, bundle: nil), forCellReuseIdentifier: conversionsRatesTableViewCell)
    }
    
    func setupTextFields() {
        baseCurrencyNameTextField.addTarget(self, action: #selector(hideTableView), for: .editingChanged)

        dateTextField.addTarget(self, action: #selector(hideTableView), for: .editingChanged)
        
        dateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    @objc func hideTableView() {
        containerView.isHidden = true
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/M/yyyy"
        dateTextField.text = dateFormatter.string(from: sender.date)
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
            .throttle(RxTimeInterval.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self](_) in
                guard let self = self else { return }
                self.conversionsRatesViewModel.getHistoricalConversionsRatesData()
        }).disposed(by: disposeBag)
    }
 
    func getHistoricalConversionsRatesData() {
        conversionsRatesViewModel.getHistoricalConversionsRatesData()
    }
}


