//
//  DetailsViewController.swift
//  CurrencyApp
//
//  Created by Salwa Hegazy on 14/11/2022.
//

import UIKit
import RxSwift

class DetailsViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Members
    let detailsViewModel = DetailsViewModel()
    let disposeBag = DisposeBag()
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        detailsViewModel.getHistoricalData()

    }
    
    //MARK: - Methods
    func setUpNavigationBar() {
        navigationItem.title = "Historical Data"
    }
    

}
