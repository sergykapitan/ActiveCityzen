//
//  EventViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 22.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @Inject var citizenApi: CitizenAPI
    var eventId: Int = -1
    var items = [AbstractTableViewItem]()

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return TableViewTypeFactory.cellForTableViewItem(tableView: tableView, item: items[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.separatorStyle = .none
        tableView.register(BigImageTitleFooterTableViewCell.nib, forCellReuseIdentifier: BigImageTitleFooterTableViewCell.identifier)
        tableView.register(TextBoxTableViewCell.nib, forCellReuseIdentifier: TextBoxTableViewCell.identifier)
        tableView.register(SingleButtonTableViewCell.nib, forCellReuseIdentifier: SingleButtonTableViewCell.identifier)
        tableView.register(UnderlinedSegmentedControlTableViewCell.nib, forCellReuseIdentifier:UnderlinedSegmentedControlTableViewCell.identifier)
        tableView.register(SingleShortButtonTableViewCell.nib, forCellReuseIdentifier: SingleShortButtonTableViewCell.identifier)
        tableView.register(ViewControllerHolderTableCell.nib, forCellReuseIdentifier: ViewControllerHolderTableCell.identifier)
        
        self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 24.0, right: 0.0)
        self.tableView.contentInsetAdjustmentBehavior = .never
        getEventById(id: eventId)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        }
        else {
            return .default
        }
    }
    
    private func getEventById(id: Int) {
        citizenApi.getEventById(id: id).subscribe(onNext: { (event) in
            self.items.append(BigImageTitleFooterItem.init(title: event.title!,
                                                           footer: "",
                                                           imageLink: event.images.first ?? ""))
            if event.place != nil {
                self.items.append(UnderlinedSegmentedControlTableItem.init(controls: [SingleSegmentControl.init(title: "Описание",
                                               position: 0,
                                               onClick: {
                    self.showDescriptionOfEvent(event: event)
                }), SingleSegmentControl.init(title: "Адрес",
                                              position: 1,
                                              onClick: {
                    self.showAddressOfEvent(event: event)
                })]))
                
            }
            if let prize = event.place?.maxDailyMax {
                let prizeEvent = SingleButtonItem(title: "До \(prize) доброрублей при посещении", backgroundColor: "F0E24C",textColor: "424242")
                self.items.append(prizeEvent)
            }
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.setLocalizedDateFormatFromTemplate("MMMMd HH:mm")
            let startDateString = formatter.string(from: event.startTime!.iso8601!)
            
            self.items.append(TextBoxItem.init(title: "О событии\n Дата и время: " + "\(startDateString)", body: event.description ?? ""))
            
            guard let place = event.place else { return }
            if  !place.qrLocation.isEmpty {
            var buttonQRCode = SingleButtonItem(title: "Показать расположение QR Кода")
            buttonQRCode.sender = Executable(block: {
                let modalVC = QRDescriptionModalViewController()
                guard let arrImage = place.qrLocationImages else { return}
                if !arrImage.isEmpty {
                    modalVC.albums = arrImage
                } else {
                    modalVC.albums.append(place.qrLocationImage ?? "")
                }
                modalVC.modalPresentationStyle = .overCurrentContext
                self.present(modalVC, animated: true, completion: nil)
            })
            self.items.append(buttonQRCode)
            }
            
            if !event.url.isEmpty {
                var buttonUrl = SingleButtonItem(title: "Сайт события")
                buttonUrl.sender = Executable(block: {
                    UIApplication.shared.open(URL.init(string: event.url)!, options: [:], completionHandler: nil)
                })
                self.items.append(buttonUrl)
            }
            self.tableView.reloadData()
        }, onError: {error in
            print(error)
        })
    }
    
    private func showDescriptionOfEvent(event: Event) {
        if items.count >= 3 {
            items.replaceSubrange((2...items.count - 1), with: [])
        }
        if let prize = event.place?.maxDailyMax {
            let prizeEvent = SingleButtonItem(title: "До \(prize) доброрублей при посещении", backgroundColor: "F0E24C",textColor: "424242")
            self.items.append(prizeEvent)
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.setLocalizedDateFormatFromTemplate("MMMMd HH:mm")
        let startDateString = formatter.string(from: event.startTime!.iso8601!)
        
        self.items.append(TextBoxItem(title: "О событии\n Дата и время: " + "\(startDateString)",
                                      body: event.description ?? ""))
        guard let place = event.place else {  return }
        if !place.qrLocation.isEmpty {
        var buttonQRCode = SingleButtonItem(title: "Показать расположение QR Кода")
        buttonQRCode.sender = Executable(block: {
            let modalVC = QRDescriptionModalViewController()
            guard let arrImage = place.qrLocationImages else { return}
            if !arrImage.isEmpty {
                modalVC.albums = arrImage
            } else {
                modalVC.albums.append(place.qrLocationImage ?? "")
            }
            modalVC.modalPresentationStyle = .overCurrentContext
            self.present(modalVC, animated: true, completion: nil)
        })
        self.items.append(buttonQRCode)
        }
        if !event.url.isEmpty {
            var buttonUrl = SingleButtonItem(title: "Сайт события")
            buttonUrl.sender = Executable(block: {
                UIApplication.shared.open(URL.init(string: event.url)!, options: [:], completionHandler: nil)
            })
            self.items.append(buttonUrl)
        }
        self.tableView.reloadData()
    }
    
    private func showAddressOfEvent(event: Event) {
        if items.count >= 3 {
            items.replaceSubrange((2...items.count - 1), with: [])
        }
        guard let place = event.place else { return }
        var placeAddress = place.address!.street
        if place.address!.num != nil && !place.address!.num!.isEmpty {
            placeAddress! += ", "
            placeAddress! += place.address!.num!
        }
        if place.schedule != nil {
            self.items.append(TextBoxItem(title: "Режим работы", body: place.schedule!))
        }
        if placeAddress != nil && !placeAddress!.isEmpty {
            self.items.append(TextBoxItem(title: "Адрес", body: placeAddress!))
        }
        
        if !place.phoneNumber.isEmpty {
              let phoneLabelEvent = SingleShortButtonImageItem.init(
                title: place.phoneNumber,imageViewName: "" ,
                backgroundColor: "00f0f8ff", titleTextButton: "#0b0904")
              phoneLabelEvent.sender = {
                  let formattedText = place.phoneNumber.applyPatternOnNumbers(pattern: "+###########", replacmentCharacter: "#")
                  self.callNumber(phoneNumber: formattedText )
              }           
              self.items.append(phoneLabelEvent)
        }
        
        let singleShortButtonImageItem = SingleShortButtonImageItem.init(
            title: "Построить маршрут",imageViewName: "iconLaunchExternalApp",
            backgroundColor: "#50AEEC",titleTextButton: "#ffffff")
        
        if let latitude = place.address?.latitude, let longitude = place.address?.longitude {
            singleShortButtonImageItem.sender = {
                openPlaceInExternalMapsApp(placeName: place.shortTitle, latitude: latitude, longitude: longitude)
                
            }
            
            let mapVC = ResizableMapViewController()
            mapVC.latitude = latitude
            mapVC.longitude = longitude
            self.items.append(singleShortButtonImageItem)
            self.items.append(ViewControllerHolderItem.init(parentViewController: self, childViewController: mapVC))
        }
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRowSender = items[indexPath.row].sender
        if selectedRowSender is Executable {
            (selectedRowSender as! Executable).execute()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barStyle = .black
        
        // Make the navigation bar background clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.tintColor = UIColor.systemBlue
        navigationController?.navigationBar.shadowImage = nil
    }
    private func callNumber(phoneNumber: String) {
        guard let url = URL(string: "telprompt://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
