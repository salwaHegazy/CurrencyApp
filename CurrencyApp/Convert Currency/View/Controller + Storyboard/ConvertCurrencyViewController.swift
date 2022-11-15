//
//  ConvertCurrencyView.swift
//  CurrencyApp
//
//  Created by Salwa Hegazy on 13/11/2022.
//

import UIKit
import DropDown
import RxSwift

class ConvertCurrencyViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var fromDropDownView: UIView!
    @IBOutlet weak var toDropDownView: UIView!
    @IBOutlet weak var fromSelectedTextField: UITextField!
    @IBOutlet weak var toSelectedTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var convertedAmountTextField: UITextField!
    
    //MARK: - Members
    
    let fromDropDown = DropDown()
    let toDropDown   = DropDown()
    let convertCurrencyViewModel = ConvertCurrencyViewModel()
    let disposeBag = DisposeBag()
    var activeTextField = UITextField()

    
    //MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAvailableCurrencies()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        subscribeToCurrenciesResponse()
        setUpTextFields()
        setUpDropDownViews()
        bindAmountTextFieldsToViewModel()
        bindConvertedAmountTextFieldsToViewModel()
        subscribeToLoading()
        subscribeToConvertCurrenciesResponse()
    }
    
//    init() {
//        // creat object from this controller
//    }
    
    // MARK: - Actions
    
    @IBAction func fromDropdownBtnPressed(_ sender: Any) {
        fromDropDown.show()
    }
    
    @IBAction func toDropdownBtnPressed(_ sender: Any) {
        toDropDown.show()
    }
    
    @IBAction func detailsBtnPressed(_ sender: Any) {
        navigateToDetailsViewController()
    }
    
    @IBAction func swapBtnPressed(_ sender: Any) {
        swapCurrencies()
    }
    
    //MARK: - Methods
    
    func setUpNavigationBar() {
        navigationItem.title = "Convert Currency"
    }
    
    func setUpTextFields() {
        fromSelectedTextField.isUserInteractionEnabled = false
        toSelectedTextField.isUserInteractionEnabled   = false
        amountTextField.delegate = self
        convertedAmountTextField.delegate = self
        amountTextField.addTarget(self, action: #selector(startToConvert), for: .editingChanged)
        convertedAmountTextField.addTarget(self, action: #selector(startToConvertResult), for: .editingChanged)
    }
    
    @objc func startToConvert () {
        bindAmountTextFieldsToViewModel()
        bindFromSelectedTextFieldToViewModel()
        bindToSelectedTextFieldToViewModel()
        convertCurrency(fromTxt: "", toTxt: "")
    }
    
    @objc func startToConvertResult () {
        bindConvertedAmountTextFieldsToViewModel()
        bindFromCurrencyValueToViewModel()
        bindToCurrencyValueToViewModel()
        convertCurrency(fromTxt: "", toTxt: "")
    }
    
    func setUpDropDownViews() {
        fromDropDown.anchorView = fromDropDownView
        toDropDown.anchorView   = toDropDownView
        fromDropDown.direction  = .bottom
        toDropDown.direction    = .bottom
        fromDropDown.bottomOffset = CGPoint(x: 0, y:(fromDropDown.anchorView?.plainView.bounds.height)!)
        toDropDown.bottomOffset   = CGPoint(x: 0, y:(toDropDown.anchorView?.plainView.bounds.height)!)
        
        fromDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            fromSelectedTextField.text = item
        }

        toDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            toSelectedTextField.text = item
        }
    }
    
    func setUpDropDownsDataSource(_ currencies : [String]) {
        fromDropDown.dataSource = currencies
        toDropDown.dataSource   = currencies
    }
    
    func bindAmountTextFieldsToViewModel() {
        amountTextField.rx.text.orEmpty.bind(to: convertCurrencyViewModel.amountToConvertBehavior).disposed(by: disposeBag)
    }
    
    func bindConvertedAmountTextFieldsToViewModel() {
        convertedAmountTextField.rx.text.orEmpty.bind(to: convertCurrencyViewModel.amountToConvertBehavior).disposed(by: disposeBag)
    }
    
    func bindFromSelectedTextFieldToViewModel() {
        fromSelectedTextField.rx.text.orEmpty.bind(to: convertCurrencyViewModel.fromCurrencyBehavior).disposed(by: disposeBag)
    }
    
    func bindToSelectedTextFieldToViewModel() {
        toSelectedTextField.rx.text.orEmpty.bind(to: convertCurrencyViewModel.toCurrencyBehavior).disposed(by: disposeBag)
    }
    
    func bindFromCurrencyValueToViewModel() {
        toSelectedTextField.rx.text.orEmpty.bind(to: convertCurrencyViewModel.fromCurrencyBehavior).disposed(by: disposeBag)
    }
    
    func bindToCurrencyValueToViewModel() {
        fromSelectedTextField.rx.text.orEmpty.bind(to: convertCurrencyViewModel.toCurrencyBehavior).disposed(by: disposeBag)
    }
    
    func subscribeToLoading() {
        convertCurrencyViewModel.loadingBehavior.subscribe(onNext: { [weak self] (isLoading) in
            guard let self = self else { return }
            if isLoading {
                self.showIndicator()
            } else {
                self.hideIndicator()
            }
        }).disposed(by: disposeBag)
    }
    
    func subscribeToShowAlert() {
        convertCurrencyViewModel.showAlertBehavior.subscribe(onNext: { [weak self] message in
           guard let self = self else { return }
            self.showAlert(withTitle: "Alert" , andMessage: message)
        }).disposed(by: disposeBag)
    }
    
    func subscribeToCurrenciesResponse() {
        convertCurrencyViewModel.currenciesModelObservable.subscribe(onNext: { currencies in
           self.setUpDropDownsDataSource(currencies)
        }).disposed(by: disposeBag)
    }
    
    func subscribeToConvertCurrenciesResponse() {
        convertCurrencyViewModel.convertedAmountObservable.subscribe(onNext: { result in
            self.convertedAmountTextField.text = result
        }).disposed(by: disposeBag)
    }
    
    func swapCurrencies() {
        if !(fromSelectedTextField.text?.isEmpty ?? true) && !(toSelectedTextField.text?.isEmpty ?? true) {
            guard let toSelectedText = toSelectedTextField.text else { return }
            toSelectedTextField.text = fromSelectedTextField.text
            fromSelectedTextField.text = toSelectedText
            
            if !(amountTextField.text?.isEmpty ?? true) || !(convertedAmountTextField.text?.isEmpty ?? true) {
                guard let convertedValue = convertedAmountTextField.text else { return }
                convertedAmountTextField.text = amountTextField.text
                amountTextField.text = convertedValue
            }
            
            if activeTextField == amountTextField {
                print("AmountTF")
            } else if activeTextField == convertedAmountTextField {
                print("ConvertedAmountTF")
            }

        } else {
            showAlert(withTitle: "Alert", andMessage: "Please Select Required Fields...")
        }
    }
    
    func navigateToDetailsViewController() {
        if let detailsVC = UIStoryboard(name: "ConvertCurrency", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
           self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    func getAvailableCurrencies(){
        convertCurrencyViewModel.getAvailableCurrencies()
    }
    
    func convertCurrency(fromTxt: String? , toTxt : String?) {
        if !(fromSelectedTextField.text?.isEmpty ?? true) && !(toSelectedTextField.text?.isEmpty ?? true)
            && ( !(amountTextField.text?.isEmpty ?? true) || !(convertedAmountTextField.text?.isEmpty ?? true) ) {
            
            convertCurrencyViewModel.convertCurrency()
            
        } else {
            
            showAlert(withTitle: "Alert", andMessage: "Please Select Required Fields...")
        }
    }
}

//MARK: - UITextField Delegate
extension ConvertCurrencyViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        if textField == amountTextField {
            convertedAmountTextField.text = ""
            bindFromCurrencyValueToViewModel()
            bindToCurrencyValueToViewModel()
        } else {
            amountTextField.text = ""
            bindFromCurrencyValueToViewModel()
            bindToCurrencyValueToViewModel()
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
            if textField.text == "0" {
                textField.text = "1"
            }
    }
    
}
