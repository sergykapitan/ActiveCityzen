//
//  UserBalanceHistoryViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 11.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import RxSwift

class UserBalanceHistoryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var items = [AbstractTableViewItem]()
    
    @IBOutlet weak var userBalanceLabel: UILabel!
    @Inject var citizenApi: CitizenAPI
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return TableViewTypeFactory.cellForTableViewItem(tableView: tableView, item: items[indexPath.row])
    }
    
    @IBOutlet weak var userBalanceBackground: UIView!
    
    @IBOutlet weak var tableViewUserBalanceHistory: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewUserBalanceHistory.delegate = self
        tableViewUserBalanceHistory.dataSource = self
        tableViewUserBalanceHistory.rowHeight = UITableView.automaticDimension
        tableViewUserBalanceHistory.estimatedRowHeight = 100
        tableViewUserBalanceHistory.separatorStyle = .none
        tableViewUserBalanceHistory.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        userBalanceBackground.clipsToBounds = true
        userBalanceBackground.layer.cornerRadius = 8
        userBalanceBackground.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        tableViewUserBalanceHistory?.register(ColoredFootersItemCell.nib, forCellReuseIdentifier: ColoredFootersItemCell.identifier)

        getUserBalance()
        getInvoices()
    }
    
    private func getUserBalance() {
        citizenApi.getUserBalance().subscribe(onNext: {[weak self] result in
            self?.userBalanceLabel.text = "\(result.balance) д₽"
        }, onError: {   error in
            print(error)
        })
    }
    
   private func getInvoices() {
        let currentDate = Date()
        let startDate = currentDate.addingTimeInterval(-30*24*60*60) // Minus 1 Month
        citizenApi.getInvoices(startTime: startDate, endTime: currentDate)
            .subscribe(onNext: { result in
                let array: Array<ColoredFootersItem> = result.list.map({  (mapper2: Invoice)-> ColoredFootersItem in
                    let dateFormatter = ISO8601DateFormatter()
                    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                    let startDate = dateFormatter.date(from: mapper2.firstTimestamp)
                    let calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: startDate!)
                    return ColoredFootersItem.init(title: "\(mapper2.quest.title)", footerLeft: "\(calendarDate.day!).\(calendarDate.month!).\(calendarDate.year!)", footerRight: "+\(Int(mapper2.amount)) д₽")})
                
                self.items.append(contentsOf:array)
                self.tableViewUserBalanceHistory.reloadData()
                print(result)
            }, onError: { error in
                print(error)
            }).disposed(by: disposeBag)
    }
}
