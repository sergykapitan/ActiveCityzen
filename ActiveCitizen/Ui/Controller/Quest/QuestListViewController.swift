//
//  QuestListViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 29.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
import YandexMobileMetrica

class QuestListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @Inject var citizenApi: CitizenAPI
    var compositeDisposable = CompositeDisposable()
    let manager = CLLocationManager()
    let queue = DispatchQueue.global(qos: .userInteractive)

    @IBOutlet weak var tableView: UITableView!
    var items = [AbstractTableViewItem]()
    
    //MARK - LifeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BigImageHorizontalSmallCardTableCell.nib, forCellReuseIdentifier: BigImageHorizontalSmallCardTableCell.identifier)
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 40
        tableView?.separatorStyle = .none
        self.tableView.contentInset = UIEdgeInsets(top: 4.0, left: 0.0, bottom: 0.0, right: 0.0)
       
        let locationDisposable = LocationProvider.instance.getCurrentLocationSingle().subscribe(onNext: { location in
            self.getQuests(location: location)
        }, onError: {error in
            self.getQuests(location: nil)
        }, onCompleted: {
            self.compositeDisposable.dispose()
        })
        compositeDisposable.insert(locationDisposable)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: animated)
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.definesPresentationContext = true
        checkInternetConection()
        openQuestListViewController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    //MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return TableViewTypeFactory.cellForTableViewItem(tableView: tableView, item: items[indexPath.row])
    }
    
    private func getQuests(location: CLLocation?) {
        var observableQuestList:  Observable<ListResponse<Quest>>? = nil
        if location == nil {
            observableQuestList = citizenApi.getQuests()
        } else {
            observableQuestList = citizenApi.getQuests(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        }
        
        observableQuestList!.map({ (questListResponse) -> [BigImageHorizontalSmallCardTableItem] in
            return questListResponse.list.map { quest -> BigImageHorizontalSmallCardTableItem in
                var chipText = ""
                if quest.maxActivityPay != nil {
                    let percentage = Int(quest.maxActivityPay!)
                    chipText = "+\(percentage) д₽"
                }
                else if quest.maxPrize != nil {
                    chipText = "+\(quest.maxPrize!) д₽"
                }
                else {
                    chipText = "До \(quest.maxDailyMax!) д₽"
                }
                
                let places = quest.places?.map({ (place) -> CroppedRightImageChipItem in
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
                    
                    let croppedImageItem = CroppedRightImageChipItem(title: place.shortTitle, imageLink: place.images.first ?? "", chipText: chipText)
                    croppedImageItem.onItemClicked = {
                        let placeViewController = PlaceViewController(nibName: "PlaceViewController", bundle: nil)
                        placeViewController.placeId = place.id
                        placeViewController.questdescription = quest.description
                        self.navigationController?.pushViewController(placeViewController, animated: true)
                    }
                    
                    var footerText = ""
                    if let distance = place.distance {
                        if distance < 1000 && distance != 0 {
                            footerText = String(format: "%.0f", distance) + " м"
                        } else if distance >= 1000 {
                            footerText = String(format: "%.0f", distance / 1000) + " км"
                        }
                    }
                    croppedImageItem.footer = footerText
                    return croppedImageItem
                })
                let item =  BigImageHorizontalSmallCardTableItem(imageLink: quest.image ?? "",
                                                                 title: quest.title,
                                                                 subtitle: quest.description,
                                                                 chipText: chipText,
                                                                 carouselTitle: "Бонусные места",
                                                                 carouselActionButtonText: "Все места",
                                                                 carouselItems: self.getPlaces(activityTypeId: quest.activityTypeId, places: places) ?? [])
                
                item.didTapShowMoreClosure = {
                    self.performSegue(withIdentifier: "fromQuestListToQuestVC", sender: quest.id)
                }
                return item
            }
        })
        .subscribe(onNext: { quests in
            self.items.append(contentsOf: quests as [AbstractTableViewItem])
            self.tableView.reloadData()
        }, onError: {error in
            print(error)
        }).disposed(by: disposeBag)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "fromQuestListToQuestVC": do {
            let destinationController = segue.destination as! QuestViewController
            destinationController.questId = sender as! Int
        }
        default: print("Unhandled segue")
            
        }
    }
    private func getPlaces(activityTypeId: Int? ,places: [CroppedRightImageChipItem]? ) ->  [CroppedRightImageChipItem]? {
        guard let questId = activityTypeId,let places = places else { return nil}
        if questId == 11 || questId == 12 {
            return nil
        } else {
            return places
        }
    }
    //MARK: - CheckInternetConection
    private func checkInternetConection() {
        if Connectivity.isConnectedToInternet {
        } else {    
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = storyboard.instantiateViewController(withIdentifier: "alert")
            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            navigationController?.pushViewController(myAlert, animated: true)
       }
   }
    func openQuestListViewController() {
    YMMYandexMetrica.reportEvent("Открытие экрана Заработать", onFailure: { (error) in
        print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
