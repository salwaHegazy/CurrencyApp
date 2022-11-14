//
//  UIViewController + Extension.swift
//  CurrencyApp
//
//  Created by Salwa Hegazy on 13/11/2022.
//

import Foundation
import UIKit
import MBProgressHUD
import CleanyModal

extension UIViewController {
    func showIndicator(withTitle title: String? = nil , and description: String? = nil) {
        let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        indicator.label.text = title
        indicator.isUserInteractionEnabled = false
        indicator.detailsLabel.text = description
        indicator.show(animated: true)
        self.view.isUserInteractionEnabled = false
    }
    
    func hideIndicator() {
        MBProgressHUD.hide(for: self.view, animated: true)
        self.view.isUserInteractionEnabled = true
    }
    
    func showAlert(withTitle: String, andMessage message: String, completion: (() -> Void)? = nil) {

        let alert = AlertViewController( title: withTitle, message: message)

        let okButton = CleanyAlertAction(title: "OK", style: .default) { (_) in
                    (completion ?? {})()
        }
        alert.addAction(okButton)

        present(alert, animated: true, completion: nil)
    }
    
}
