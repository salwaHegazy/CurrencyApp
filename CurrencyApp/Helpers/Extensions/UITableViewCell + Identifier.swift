//
//  UITableViewCell + Identifier.swift
//  CurrencyApp
//
//  Created by Salwa Hegazy on 20/11/2022.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var identifier: String {
        String(describing: Self.self)
    }
}
