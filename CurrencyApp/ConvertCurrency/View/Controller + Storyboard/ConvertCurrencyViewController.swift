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
    @IBOutlet weak var swapButton: UIButton!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var historicalDataButton: UIButton!
    @IBOutlet weak var conversionsRatesButton: UIButton!
    @IBOutlet weak var buttonsContainer: UIStackView!
    
    //MARK: - Members
    let fromDropDown = DropDown()
    let toDropDown   = DropDown()
    let convertCurrencyViewModel = ConvertCurrencyViewModel()
    let disposeBag = DisposeBag()
    var isConvertCurrencyEnabled : Bool?

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
        bindAmountTextFieldToViewModel()
        bindConvertedAmountTextFieldsToViewModel()
        subscribeToLoading()
        subscribeIsSwapCurrenciesButtonEnabled()
        subscribeToConvertCurrenciesResponse()
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Actions
    @IBAction func fromDropdownBtnPressed(_ sender: Any) {
        fromDropDown.show()
    }
    
    @IBAction func toDropdownBtnPressed(_ sender: Any) {
        toDropDown.show()
    }
    
    @IBAction func detailsBtnPressed(_ sender: Any) {
        showOptionsButtonsToNavigate()
    }
   
    @IBAction func swapBtnPressed(_ sender: Any) {
        swapCurrencies(fromTextFieldTxt: fromSelectedTextField.text, toTextFieldTxt: toSelectedTextField.text,
                       amountTextFieldTxt: amountTextField.text, convertedAmountTextFieldTxt: convertedAmountTextField.text)
    }
    
    @IBAction func historicalDataBtnPressed(_ sender: Any) {
        navigateToHistoricalDataViewController()
    }
    
    @IBAction func conversionsRatesBtnPressed(_ sender: Any) {
        navigateToConversionsRatesViewController()
    }
    
    //MARK: - Methods
    func setUpNavigationBar() {
        self.title = "Convert Currency"
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
        bindAmountTextFieldToViewModel()
        bindFromSelectedTextFieldToViewModel()
        bindToSelectedTextFieldToViewModel()
        convertCurrency()
    }
    
    @objc func startToConvertResult () {
        bindConvertedAmountTextFieldsToViewModel()
        bindFromCurrencyValueToViewModel()
        bindToCurrencyValueToViewModel()
        convertCurrency()
    }
    
    func setUpDropDownViews() {
        fromDropDown.anchorView = fromDropDownView
        toDropDown.anchorView   = toDropDownView
        fromDropDown.direction  = .bottom
        toDropDown.direction    = .bottom
        fromDropDown.bottomOffset = CGPoint(x: 0, y:(fromDropDown.anchorView?.plainView.bounds.height)!)
        toDropDown.bottomOffset   = CGPoint(x: 0, y:(toDropDown.anchorView?.plainView.bounds.height)!)
        
        // setUp DropDown appearance
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.blue
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 16)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().cellHeight = 50
        
        // setup DropDown Selection
        fromDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            fromSelectedTextField.text = item
        }

        toDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            toSelectedTextField.text = item
        }
    }
    
    func setUpDropDownListsDataSource(_ currencies : [String]) {
        fromDropDown.dataSource = currencies
        toDropDown.dataSource   = currencies
    }
    
    func bindAmountTextFieldToViewModel() {
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
           self.setUpDropDownListsDataSource(currencies)
        }).disposed(by: disposeBag)
    }
    
    func subscribeToConvertCurrenciesResponse() {
        convertCurrencyViewModel.convertedAmountObservable.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            
            if self.convertedAmountTextField.text?.isEmpty ?? true {
                self.convertedAmountTextField.text = result
            } else {
                self.amountTextField.text = result
            }
            
        }).disposed(by: disposeBag)
    }
    
    func subscribeIsSwapCurrenciesButtonEnabled() {
        convertCurrencyViewModel.isSwapEnabled.bind(to: swapButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    func swapCurrencies(fromTextFieldTxt : String? , toTextFieldTxt : String? ,
                        amountTextFieldTxt : String? , convertedAmountTextFieldTxt : String?) {

        guard let toSelectedText = toTextFieldTxt else { return }
        toSelectedTextField.text = fromTextFieldTxt
        fromSelectedTextField.text = toSelectedText
        
        guard let convertedValue = convertedAmountTextFieldTxt else { return }
        convertedAmountTextField.text = amountTextFieldTxt
        amountTextField.text = convertedValue

    }
    
    func showOptionsButtonsToNavigate() {
        if buttonsContainer.isHidden {
           buttonsContainer.isHidden = false
        } else {
           buttonsContainer.isHidden = true
        }
    }
    
    func navigateToHistoricalDataViewController() {
        if let historicalDataVC = UIStoryboard(name: "ConvertCurrency", bundle: nil).instantiateViewController(withIdentifier: HistoricalDataViewController .identifier) as? HistoricalDataViewController {
           self.navigationController?.pushViewController(historicalDataVC, animated: true)
        }
    }
    
    func navigateToConversionsRatesViewController() {
        if let conversionsRatesVC = UIStoryboard(name: "ConvertCurrency", bundle: nil).instantiateViewController(withIdentifier: ConversionsRatesViewController.identifier) as? ConversionsRatesViewController {
           self.navigationController?.pushViewController(conversionsRatesVC, animated: true)
        }
    }
    
    func getAvailableCurrencies() {
        convertCurrencyViewModel.getAvailableCurrencies()
    }
    
    func convertCurrency() {
        if !(fromSelectedTextField.text?.isEmpty ?? true) && !(toSelectedTextField.text?.isEmpty ?? true)
            && ( !(amountTextField.text?.isEmpty ?? true) || !(convertedAmountTextField.text?.isEmpty ?? true) ) {
            
            convertCurrencyViewModel.convertCurrency()
            
        } else {
            
            showAlert(withTitle: "Alert", andMessage: "Please Fill Required Fields...")
        }
    }
}

//MARK: - UITextField Delegate
extension ConvertCurrencyViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
