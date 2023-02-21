//
//  EventListViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 21.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class EventListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return TableViewTypeFactory.cellForTableViewItem(tableView: tableView, item: items[indexPath.row])
    }
    
    
    var items = [AbstractTableViewItem]()
    
    @Inject var citizenApi: CitizenAPI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.delegate = self
        tableView?.dataSource = self
        navigationItem.title = "События"
        navigationItem.backBarButtonItem?.title = " "
        tableView?.register(ElementLeftImagePreviewCell.nib,forCellReuseIdentifier: ElementLeftImagePreviewCell.identifier)
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 40
        tableView?.separatorStyle = .none
        getEvents()
    }
    
    private func getEvents() {
        citizenApi.getEvents().map { (events) -> Array<AbstractTableViewItem> in
            return events.list.map { (event: Event) -> AbstractTableViewItem in
                
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ru_RU")
                formatter.setLocalizedDateFormatFromTemplate("MMMMd")
                var readableStartDate = ""
                if event.startTime != nil && event.endTime != nil && !Calendar.current.isDate(event.startTime!.iso8601!, inSameDayAs: event.endTime!.iso8601!) {
                    let startDateString = formatter.string(from: event.startTime!.iso8601!)
                    let endDateString = formatter.string(from: event.endTime!.iso8601!)
                    readableStartDate = "С " + startDateString + " по " + endDateString
                } else if event.startTime != nil && event.endTime != nil && Calendar.current.isDate(event.startTime!.iso8601!, inSameDayAs: event.endTime!.iso8601!) {
                    let startDateString = formatter.string(from: event.startTime!.iso8601!)
                    readableStartDate = startDateString
                } else if event.startTime != nil {
                    let startDateString = formatter.string(from: event.startTime!.iso8601!)
                    readableStartDate = "С " + startDateString
                }
                
                let item =
                    ElementLeftImagePreviewItem.init(image: event.images.first ?? "",
                                                     preTitle: event.type ?? "",
                                                     title: event.title ?? "",
                                                     subTitle: readableStartDate,
                                                     footer: event.place?.shortTitle ?? "")
                item.sender = event.id
                return item
            }
        }.subscribe(onNext: { (mappedTableViewItems: Array<AbstractTableViewItem>)  in
            self.items.append(contentsOf: mappedTableViewItems)
            self.tableView?.reloadData()
        }, onError: { error in
            print(error)
        }).disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = items[indexPath.row].sender
        self.performSegue(withIdentifier: "fromEventListToEventVC", sender: id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "fromEventListToEventVC":
            let targetController = segue.destination as! EventViewController
            targetController.eventId = sender as! Int
        default:
            print("Unhandled segue")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    override func viewDidAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isTranslucent = false
    }
    
}
