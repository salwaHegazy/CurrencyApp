//
//  DetailsViewController.swift
//  CurrencyApp
//
//  Created by Salwa Hegazy on 14/11/2022.
//

import UIKit
import RxSwift

class HistoricalDataViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    
    //MARK: - Members
    let historicalDataTableViewCell = "HistoricalDataTableViewCell"
    let historicalDataViewModel = HistoricalDataViewModel()
    let disposeBag = DisposeBag()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setupTableView()
        bindToHiddenTable()
        subscribeToLoading()
        subscribeToResponse()
        getHistoricalData()
    }
    
    //MARK: - Methods
    func setUpNavigationBar() {
        self.title = "Historical Data"
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: historicalDataTableViewCell, bundle: nil), forCellReuseIdentifier: historicalDataTableViewCell)
    }
    
    func bindToHiddenTable() {
        historicalDataViewModel.isTableHiddenObservable.bind(to: containerView.rx.isHidden).disposed(by: disposeBag)
    }
    
    func subscribeToLoading() {
        historicalDataViewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
            if isLoading {
                self.showIndicator(withTitle: "", and: "")
            } else {
                self.hideIndicator()
            }
        }).disposed(by: disposeBag)
    }
    
    func subscribeToResponse() {
        historicalDataViewModel.historicalDataModelObservable
            .bind(to: self.tableView
                .rx
                .items(cellIdentifier: historicalDataTableViewCell,
                       cellType: HistoricalDataTableViewCell.self)) { row, currencyRates, cell in
                cell.configCell(data: currencyRates)
                
        }
        .disposed(by: disposeBag)
    }
    
    func getHistoricalData() {
        historicalDataViewModel.getHistoricalData()
    }
}
