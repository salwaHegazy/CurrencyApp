//
//  HistoricalDataTableViewCell.swift
//  CurrencyApp
//
//  Created by Salwa Hegazy on 16/11/2022.
//

import UIKit

class HistoricalDataTableViewCell: UITableViewCell {

    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var firstCurrNameLabel: UILabel!
    @IBOutlet weak var firstCurrRateLabel: UILabel!
    @IBOutlet weak var secondCurrencyNameLabel: UILabel!
    @IBOutlet weak var secondCurrRateLabel: UILabel!
    @IBOutlet weak var thirdCurrencyNameLabel: UILabel!
    @IBOutlet weak var thirdCurrRateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configCell (data : CurrencyModel) {
        dataLabel.text = data.date
        firstCurrNameLabel.text = "AUD"
        firstCurrRateLabel.text = String(data.rate.aud)
        secondCurrencyNameLabel.text = "CAD"
        secondCurrRateLabel.text = String(data.rate.cad)
        thirdCurrencyNameLabel.text = "USD"
        thirdCurrRateLabel.text = String(data.rate.usd)
    }
    
}
