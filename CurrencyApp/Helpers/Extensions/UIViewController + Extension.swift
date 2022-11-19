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
import Charts

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
    
    func hideKeyboardWhenTappedAround() {
       let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
       view.addGestureRecognizer(tap)

    }

    @objc func dismissKeyboard() {
       view.endEditing(true)
    }
    
}

//MARK: - BarChartView
extension BarChartView {
    
    func createChart( xValues: [String] , yValuesArr: [[Double]]) {
        
        self.drawBarShadowEnabled = false
        self.drawValueAboveBarEnabled = false
        self.highlightFullBarEnabled = false
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1

        let leftAxis = self.leftAxis
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.labelFont = .systemFont(ofSize: 13)
        leftAxis.labelCount = 8
        
        self.rightAxis.enabled = false
        
        
        //configure the axis
        let chartFormatter = BarChartFormatter(labels: xValues)
        let xAxis = self.xAxis
        xAxis.valueFormatter = chartFormatter
        xAxis.labelPosition = .top
        xAxis.labelFont = .systemFont(ofSize: 13)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        
       
        //configure legend
        let legend = self.legend
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .bottom
        legend.orientation = .horizontal
        legend.drawInside = false
        legend.form = .square
        legend.formToTextSpace = 4
        legend.font = UIFont(name: "HelveticaNeue-Light", size: 13)!
        legend.xEntrySpace = 6
        
        var entries = [BarChartDataEntry]()
        
        for i in 0..<xValues.count {
            entries.append(
                BarChartDataEntry(x: Double(i),
                                  yValues: yValuesArr[i])
            )
        }
        
        let set = BarChartDataSet(entries: entries, label: "Currency Rates")
        set.drawIconsEnabled = false
        set.colors = ChartColorTemplates.colorful()
        
        let data = BarChartData(dataSet: set)
        data.setValueFont(.systemFont(ofSize: 13, weight: .light))
        data.setValueTextColor(.white)
        
        self.fitBars = true
        self.data = data

    }
 
    class BarChartFormatter: NSObject, AxisValueFormatter {

      var labels: [String] = []

      func stringForValue(_ value: Double, axis: AxisBase?) -> String {
          return labels[Int(value)]
      }

      init(labels: [String]) {
          super.init()
          self.labels = labels
      }
    }
}

