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
    let currenciesData : [String] = ["AED" , "AFN" , "ALL" , "AMD"]
    let convertCurrencyViewModel = ConvertCurrencyViewModel()
    let disposeBag = DisposeBag()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
        setUpDropDownViews()
        bindTextFieldsToViewModel()
        subscribeToLoading()
        subscribeToCurrenciesResponse()
        
    }
    
    // MARK: - Actions
    
    @IBAction func fromDropdownBtnPressed(_ sender: Any) {
        fromDropDown.show()
    }
    
    @IBAction func toDropdownBtnPressed(_ sender: Any) {
        toDropDown.show()
    }
    
    @IBAction func detailsBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func swapBtnPressed(_ sender: Any) {
        swapCurrencies()
    }
    
    
    //MARK: - Methods
    
    func setUpTextFields() {
        fromSelectedTextField.isUserInteractionEnabled = false
        toSelectedTextField.isUserInteractionEnabled = false
        convertedAmountTextField.isUserInteractionEnabled = false
    }
    
    func setUpDropDownViews() {
        fromDropDown.anchorView = fromDropDownView
        toDropDown.anchorView   = toDropDownView
        fromDropDown.dataSource = currenciesData
        toDropDown.dataSource   = currenciesData
        fromDropDown.direction  = .bottom
        toDropDown.direction    = .bottom
        fromDropDown.bottomOffset = CGPoint(x: 0, y:(fromDropDown.anchorView?.plainView.bounds.height)!)
        toDropDown.bottomOffset   = CGPoint(x: 0, y:(toDropDown.anchorView?.plainView.bounds.height)!)
        // get selected value from dropdown
        fromDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            fromSelectedTextField.text = item
        }

        toDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            toSelectedTextField.text = item

        }
    }
    
    func bindTextFieldsToViewModel() {
        fromSelectedTextField.rx.text.orEmpty.bind(to: convertCurrencyViewModel.fromCurrencyBehavior).disposed(by: disposeBag)
        toSelectedTextField.rx.text.orEmpty.bind(to: convertCurrencyViewModel.toCurrencyBehavior).disposed(by: disposeBag)
        amountTextField.rx.text.orEmpty.bind(to: convertCurrencyViewModel.amountToConvertBehavior).disposed(by: disposeBag)
    }
    
    func subscribeToLoading() {
        convertCurrencyViewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
            if isLoading {
                self.showIndicator()
            } else {
                self.hideIndicator()
            }
        }).disposed(by: disposeBag)
    }
    
    func subscribeToCurrenciesResponse() {
//        convertCurrencyViewModel.currenciesModelObservable.subscribe(onNext: {
//            if $0.success {
//
//            } else {
//
//            }
//        }).disposed(by: disposeBag)
    }
    
    func swapCurrencies() {
        if !(fromSelectedTextField.text?.isEmpty ?? true) && !(toSelectedTextField.text?.isEmpty ?? true) {
            guard let toSelectedText = toSelectedTextField.text else { return }
            toSelectedTextField.text = fromSelectedTextField.text
            fromSelectedTextField.text = toSelectedText
        } else {
            showAlert(withTitle: "Alert", andMessage: "Please Select From And To Currencies Values")
        }
    }
    
}
