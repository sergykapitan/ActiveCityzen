//
//  PlaceViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 03.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import CoreLocation

class PlaceViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    @Inject var citizenApi: CitizenAPI
    
    var placeId: Int = -1
    var items = [AbstractTableViewItem]()
    var questdescription: String?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return TableViewTypeFactory.cellForTableViewItem(tableView: tableView, item: items[indexPath.row])
    }
    
    override func viewDidLoad() {
        self.definesPresentationContext = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BigImageTitleFooterTableViewCell.nib, forCellReuseIdentifier: BigImageTitleFooterTableViewCell.identifier)
        tableView.register(UnderlinedSegmentedControlTableViewCell.nib, forCellReuseIdentifier: UnderlinedSegmentedControlTableViewCell.identifier)
        tableView.register(TextBoxTableViewCell.nib, forCellReuseIdentifier: TextBoxTableViewCell.identifier)
        tableView.register(SingleShortButtonTableViewCell.nib, forCellReuseIdentifier: SingleShortButtonTableViewCell.identifier)
        tableView.register(ViewControllerHolderTableCell.nib, forCellReuseIdentifier: ViewControllerHolderTableCell.identifier)
        tableView.register(SingleButtonTableViewCell.nib, forCellReuseIdentifier: SingleButtonTableViewCell.identifier)
        
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 40
        tableView?.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        self.navigationController?.navigationBar.backItem?.title = " "
        
        getPlaceById(id: placeId)

    }
    
    func getPlaceById(id: Int) {
        citizenApi.getPlaceById(id: id).subscribe(onNext: { place in
            var placeAddress = place.address!.street
            if place.address!.num != nil && !place.address!.num!.isEmpty {
                placeAddress! += ", "
                placeAddress! += place.address!.num!
            }
            self.items.append(BigImageTitleFooterItem(title: place.shortTitle, footer: placeAddress ?? "", imageLink: place.images.first ?? ""))

            self.items.append(UnderlinedSegmentedControlTableItem.init(controls: [
                SingleSegmentControl.init(title: "О месте", position: 0, onClick: {
                self.showDescriptionOfPlace(place: place)
            }), SingleSegmentControl.init(title: "Адрес", position: 1, onClick: {
                self.showAddressOfPlace(place: place)
            })])
            )
            self.showDescriptionOfPlace(place: place)
            self.tableView.reloadData()
        }, onError: {   error in
            print(error)
        }).disposed(by: disposeBag)
    }
    
    func showDescriptionOfPlace(place: Place ) {
        if items.count >= 3 {
            items.replaceSubrange((2...items.count - 1), with: [])
        }
        if let prize = place.maxDailyMax {
            let prizeEvent = SingleButtonItem(title: "До \(prize) доброрублей при посещении", backgroundColor: "F0E24C",textColor: "424242")
            self.items.append(prizeEvent)
        }
        self.items.append(TextBoxItem(title: "Описание", body: place.description ))
        self.items.append(TextBoxItem(title: "Как получить дополнительные Доброрубли", body: questdescription ?? ""))
        if !place.qrLocation.isEmpty{
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
        self.tableView.reloadData()
    }

    func showAddressOfPlace(place: Place) {
        print("items.countPlace = \(items.count)")
        if items.count >= 3 {
            print("items.countPlace = \(items.count)")
            items.replaceSubrange((2...items.count - 1), with: [])
        }
        var placeAddress = place.address!.street
        if place.address!.num != nil && !place.address!.num!.isEmpty {
            placeAddress! += ", "
            placeAddress! += place.address!.num!
        }
        if place.schedule != nil {
            self.items.append(TextBoxItem(title: "Режим работы", body: place.schedule!))}
        self.items.append(TextBoxItem(title: "Адрес", body: placeAddress ?? ""))
        self.items.append(TextBoxItem(title: "", body: place.phoneNumber))
        let singleShortButtonImageItem =  SingleShortButtonImageItem.init(title: "Построить маршрут",
                                         imageViewName: "iconLaunchExternalApp",
                                         backgroundColor: "#50AEEC",
                                         titleTextButton: "FCFFFD")
        if let placeCenterPolygon = place.placePolygons?.first?.coordinates {
                let centerPoly = centerPolygon(coordinate: placeCenterPolygon)
                let latitude = centerPoly[0]
                let longitude = centerPoly[1]
                    singleShortButtonImageItem.sender = {
                        openPlaceInExternalMapsApp(placeName: place.shortTitle, latitude: latitude, longitude: longitude)}
                    
                    let mapVC = ResizableMapViewController()
                    mapVC.latitude = latitude
                    mapVC.longitude = longitude
                    self.items.append(singleShortButtonImageItem)
                    self.items.append(ViewControllerHolderItem.init(parentViewController: self, childViewController: mapVC))
            self.tableView.reloadData()
        } else {
            guard let latitude = place.address?.latitude,let longitude = place.address?.longitude else { return }
                singleShortButtonImageItem.sender = {
                    openPlaceInExternalMapsApp(placeName: place.shortTitle, latitude: latitude, longitude: longitude)}
                
                let mapVC = ResizableMapViewController()
                mapVC.latitude = latitude
                mapVC.longitude = longitude
                self.items.append(singleShortButtonImageItem)
                self.items.append(ViewControllerHolderItem.init(parentViewController: self, childViewController: mapVC))
            self.tableView.reloadData()
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
    }
    
    private func centerPolygon(coordinate:[[Double]]) -> [Double]{
        var coordinateCenter = [Double]()
        var arrLatitude = [Double]()
        var arrLongitude = [Double]()
        coordinate.map { (double) in
            arrLatitude.append(double[0])
            arrLongitude.append(double[1])
        }
        let sumLatitude =  arrLatitude.reduce(0) { (result, double) in
            result + double
        }
        let sumLongitude = arrLongitude.reduce(0) { (result, double) in
            result + double
        }
        let latitude = sumLatitude / Double(arrLatitude.count)
        let longitude = sumLongitude / Double(arrLongitude.count)
        coordinateCenter.append(latitude)
        coordinateCenter.append(longitude)
        return coordinateCenter
    }
    
}
