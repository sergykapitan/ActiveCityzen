//
//  DobromarketOrderListViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 09.10.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class DobromarketOrderListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return TableViewTypeFactory.cellForTableViewItem(tableView: tableView, item: items[indexPath.row])
    }
    
    
    @Inject var citizenApi: CitizenAPI
    
    @IBOutlet weak var tableView: UITableView!
    
    var items = [AbstractTableViewItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        self.navigationItem.backButtonTitle = " "
        
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        tableView.register(MultilineColorfulRightFooterTableViewCell.nib, forCellReuseIdentifier: MultilineColorfulRightFooterTableViewCell.identifier)
        getDobroOrders()
    }
    
    func getDobroOrders() {
        citizenApi.getDobroOrders().subscribe(onNext:{  ordersList in
            let multilineTableViewItems = ordersList.list.map { (dobroOrder) -> MultilineColorfulRightFooterItem in
                let multilineItem = MultilineColorfulRightFooterItem.init(preTitle: dobroOrder.createdAt.iso8601?.userFriendlyDateTime ?? "", title: dobroOrder.header, subTitle: dobroOrder.organizationName, colorfulFooterText: "\(dobroOrder.price) д₽")
                if dobroOrder.used {
                    multilineItem.setTransparency(transparency: 0.52)
                }
                multilineItem.sender = dobroOrder.orderId
                return multilineItem
            }
            self.items.append(contentsOf: multilineTableViewItems)
            self.tableView.reloadData()
        }, onError: {error in
            print(error)
        }).disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedRow = items[indexPath.row] as? MultilineColorfulRightFooterItem {
            self.performSegue(withIdentifier: "fromDobroOfferListToDobroOfferVC", sender: selectedRow.sender as! Int)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "fromDobroOfferListToDobroOfferVC":
            let destination = segue.destination as! DobromarketOrderViewController
            destination.orderId = sender as! Int
        default:
            print("Unhandled segue")
        }
    }
}
