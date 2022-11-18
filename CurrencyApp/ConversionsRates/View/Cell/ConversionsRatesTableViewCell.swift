//
//  ConversionsRatesTableViewCell.swift
//  CurrencyApp
//
//  Created by Salwa Hegazy on 18/11/2022.
//

import UIKit

class ConversionsRatesTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyRateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell (data : CurrencyRateModel) {
        currencyNameLabel.text = data.currencyName
        currencyRateLabel.text = String(data.rate)
    }
}
