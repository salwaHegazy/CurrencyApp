//
//  ConvertCurrencyView.swift
//  CurrencyApp
//
//  Created by Salwa Hegazy on 13/11/2022.
//

import UIKit
import DropDown

class ConvertCurrencyView: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var fromDropDownView: UIView!
    @IBOutlet weak var toDropDownView: UIView!
    @IBOutlet weak var fromSelectedLabel: UILabel!
    @IBOutlet weak var toSelectedLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var convertedAmountLabel: UILabel!
    
    //MARK: - Members
    
    let fromDropDown = DropDown()
    let toDropDown   = DropDown()
    let data : [String] = []
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDropDownViews()
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
    
    //MARK: - Methods
    
    func setUpDropDownViews() {
        fromDropDown.anchorView = fromDropDownView
        toDropDown.anchorView = toDropDownView
        fromDropDown.dataSource = data
        toDropDown.dataSource = data
        fromDropDown.direction = .bottom
        toDropDown.direction = .bottom
        fromDropDown.bottomOffset = CGPoint(x: 0, y:(fromDropDown.anchorView?.plainView.bounds.height)!)
        toDropDown.bottomOffset = CGPoint(x: 0, y:(toDropDown.anchorView?.plainView.bounds.height)!)
        // get selected value from dropdown
        fromDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            fromSelectedLabel.text = item
        }

        toDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            toSelectedLabel.text = item

        }

    }

}
