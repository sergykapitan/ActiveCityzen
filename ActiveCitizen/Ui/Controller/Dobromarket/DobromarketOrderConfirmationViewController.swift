//
//  DobromarketOrderConfirmationViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 07.10.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import RxSwift

class DobromarketOrderConfirmationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items = [AbstractTableViewItem]()
    
    var dobroOrder: DobroOrder?
    @Inject var citizenApi: CitizenAPI
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.backButtonTitle = " "
        tableView.register(NarrowImageTableViewCell.nib, forCellReuseIdentifier: NarrowImageTableViewCell.identifier)
        tableView.register(TitleBadgeChipFooterTableViewCell.nib, forCellReuseIdentifier: TitleBadgeChipFooterTableViewCell.identifier)
        tableView.register(ExpandableTextBoxTableViewCell.nib, forCellReuseIdentifier: ExpandableTextBoxTableViewCell.identifier)
        tableView.register(MultilineSpannedTextTableViewCell.nib, forCellReuseIdentifier: MultilineSpannedTextTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInsetAdjustmentBehavior = .never

        guard let dobroOrder = dobroOrder else { return }
        citizenApi.getDobroOfferById(id: dobroOrder.offerId).subscribe(onNext: {  dobroOffer in
            self.items.append(NarrowImageItem(imageLink: dobroOffer.imageUrl))
            self.items.append(TitleBadgeChipFooterItem.init(badgeImageLink: dobroOffer.logoUrl, title: dobroOffer.header, header: "", chipText: "\(dobroOffer.price) д₽", footer: ""))
            
            let dobroOrderCreationDate = dobroOrder.createdAt.iso8601
          
            
            self.items.append(ExpandableTextBoxItem.init(preTitle: dobroOrder.createdAt.iso8601?.userFriendlyDateTime ?? "kek", expandableBody: dobroOffer.description, collapsedAttributedLink: "Читать далее"))
            
            self.items.append(MultilineSpannedTextBoxItem.init(title: "Предложение \(dobroOffer.header) активировано", subtitle1: dobroOrder.offerRule.startTime.iso8601?.userFriendlyDateTime ?? "huh", subtitle2: "\(dobroOrder.organizationName))", footer: "Промокод: \(dobroOrder.coupon)", bottomCaption: "Меньше минуты назад"))
            
            guard let multilineItem = self.items.first(where: { tableViewItem -> Bool in
                tableViewItem.type == .multilineSpannedTextBox
            }) else { return }
            
            Observable<Int>.interval(.seconds(60), scheduler: SerialDispatchQueueScheduler.init(qos: .default)).observeOn(MainScheduler.instance)
                .map({ (intValue) -> Int in
                    intValue + 1
                })
                    .subscribe(onNext: { (time: Int) in
                    (multilineItem as! MultilineSpannedTextBoxItem).bottomCaption = "\(time) минут(ы) назад"
                        self.tableView.reloadData()
                }
            )
            self.tableView.reloadData()
            print("data reloaded")
        }, onError: {   error in
            print(error)
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return TableViewTypeFactory.cellForTableViewItem(tableView: tableView, item: items[indexPath.row])
    }
    
}
