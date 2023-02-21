//
//  QuestViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 29.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift

class QuestViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @Inject var citizenApi: CitizenAPI
    
    var items = [AbstractTableViewItem]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return TableViewTypeFactory.cellForTableViewItem(tableView: tableView, item: items[indexPath.row])
    }
    
    var questId: Int = -1
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("QuestViewController")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BigImageTitleFooterTableViewCell.nib, forCellReuseIdentifier: BigImageTitleFooterTableViewCell.identifier)
        tableView.register(UnderlinedSegmentedControlTableViewCell.nib, forCellReuseIdentifier: UnderlinedSegmentedControlTableViewCell.identifier)
        tableView.register(TextBoxTableViewCell.nib, forCellReuseIdentifier: TextBoxTableViewCell.identifier)
        tableView.register(RightSmallClippedImageTableViewCell.nib, forCellReuseIdentifier: RightSmallClippedImageTableViewCell.identifier)
        
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 40
        tableView?.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        
        LocationProvider.instance.getCurrentLocationSingle().subscribe(onNext: { [self] location in
            self.getQuestById(id: questId, location: location)
        }, onError: { error in
            self.getQuestById(id: self.questId, location: nil)
        }).disposed(by: disposeBag)
    }
    
    func getQuestById(id: Int, location: CLLocation?) {
        var questObservable: Observable<Quest>? = nil
        if location == nil {
            questObservable = citizenApi.getQuestById(id: id) }
        else {
            questObservable = citizenApi.getQuestById(id: id, latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        }
        
        questObservable!.subscribe(onNext: { quest in
            self.items.append(BigImageTitleFooterItem(title: quest.title, footer: quest.places?.first?.shortTitle ?? "", imageLink: quest.image ?? ""))
            
            if !quest.places!.isEmpty {
                self.items.append(UnderlinedSegmentedControlTableItem(controls:
                    [
                        SingleSegmentControl(title: "Все места", position: 0, onClick:
                            {self.displayPlacesOfQuest(quest: quest)}),
                        SingleSegmentControl(title: "Информация", position: 1, onClick: {self.displayDescriptionOfQuest(quest: quest)})
                    ]
                    )
                )
                self.displayPlacesOfQuest(quest: quest)
            } else {
                self.items.append(TextBoxItem(title: "", body: quest.description))
                self.items.append(TextBoxItem(title: "Дополнительно", body: quest.additional))
            }
            self.tableView.reloadData()
        }, onError: { error in
            print(error)
        }).disposed(by: disposeBag)
    }
    
    func displayPlacesOfQuest(quest: Quest) {
        if items.count >= 3 {
            print(items.count)
            items.replaceSubrange((2...items.count - 1), with: [])
        }
        
        quest.places?.forEach { place in
            var placeAddress = place.address!.street
            if place.address!.num != nil && !place.address!.num!.isEmpty {
                placeAddress! += ", "
                placeAddress! += place.address!.num!
            }
            
            var chipText = ""
            if place.dailyMax != nil {
                chipText = "+\(place.dailyMax!) д₽"
            }
            else if place.prize != nil {
                chipText = "+\(place.prize!) д₽"
            }
            else {
                chipText = ""
            }
            
            let item = RightSmallClippedImageItem(imageLink: place.images.first ?? "", title: place.shortTitle ?? "", subtitle: placeAddress!, chipText: chipText)
            item.onItemClicked = {
                let placeViewController = PlaceViewController(nibName: "PlaceViewController", bundle: nil)
                placeViewController.placeId = place.id 
                placeViewController.questdescription = quest.description
                self.navigationController?.pushViewController(placeViewController, animated: true)
                self.items.append(item)
            }
           
            var footerText = ""
            if let distance = place.distance {
                if distance < 1000 && distance != 0  {
                    footerText = String(format: "%.0f", distance) + " м"
                } else if distance >= 1000 {
                    footerText = String(format: "%.0f", distance / 1000) + " км"
                }
            }
            item.footer = footerText
            self.items.append(item)
            
            self.tableView.reloadData()
        }}
    
    func displayDescriptionOfQuest(quest: Quest) {
        if items.count >= 3 {
            items.replaceSubrange((2...items.count - 1), with: [])
        }
        
        self.items.append(TextBoxItem(title: "", body: quest.description))
        self.items.append(TextBoxItem(title: "Дополнительно", body: quest.additional))
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barStyle = .black
        // Make the navigation bar background clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}
