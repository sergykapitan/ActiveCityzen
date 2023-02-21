//
//  MainViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 11.10.2019.
//  Copyright © 2019 Novotorica. All rights reserved.
//

import UIKit
import CoreMotion
import RxSwift
import CoreLocation
import HealthKit
import YandexMobileMetrica
import Instructions


class MainViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @Inject var citizenApi: CitizenAPI
    @Inject var healthProvider: HealthProvider
    @Inject var physicalActivitySerivce: PhysicalActivityService
    
    var refreshControl: UIRefreshControl!
    let coachMarksController = CoachMarksController()
    
   
    
    @IBOutlet weak var tableView: UITableView!
    
    var items = [AbstractTableViewItem]()
    
    let healthStore = HKHealthStore()
    let workoutConfiguration = HKWorkoutConfiguration()
    weak var snapshotDelegate: CoachMarksControllerDelegate?
    
    
    let labelDescription: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        page.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        page.backgroundColor = .clear
        page.numberOfPages = 7
        page.pageIndicatorTintColor = .white
        page.currentPageIndicatorTintColor = .blue
        return page
    }()

    let imageTraning: UIImageView = {
        let image = UIImageView()
        return image
    }()
    @Inject private var physicalActivityService: PhysicalActivityService

    
    //MARK - LifeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        setupView()
        getKeyForAppMetrica()
        
        
       
        
        self.coachMarksController.delegate = self
        self.coachMarksController.animationDelegate = self
        self.coachMarksController.dataSource = self
        
        coachMarksController.overlay.isUserInteractionEnabled = true
        coachMarksController.overlay.backgroundColor = UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 0.64)
        
        let skipView = CoachMarkSkipDefaultView()
        skipView.isStyledByInstructions = false
        skipView.setTitle("Пропустить", for: .normal)
        skipView.setTitleColor(UIColor.white, for: .normal)
        skipView.setBackgroundImage(nil, for: .normal)
        skipView.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        skipView.titleLabel?.textAlignment = .right
        skipView.setBackgroundImage(nil, for: .highlighted)
        skipView.layer.cornerRadius = 0
        skipView.backgroundColor = .clear
        self.coachMarksController.skipView = skipView
        
        
        
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = .blue
        self.refreshControl.bounds = CGRect(x: refreshControl.bounds.origin.x,
                                        y: 50,
                                        width: refreshControl.bounds.size.width,
                                        height: refreshControl.bounds.size.height)
        self.refreshControl.addTarget(self, action: #selector(startRefreshing), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        tableView.register(MainScreenItemCell.nib, forCellReuseIdentifier: MainScreenItemCell.identifier)
        tableView.register(HorizontalLeftImagePreviewCollectionTableViewCell.nib, forCellReuseIdentifier: HorizontalLeftImagePreviewCollectionTableViewCell.identifier)
        tableView.register(ViewControllerHolderTableCell.nib, forCellReuseIdentifier: ViewControllerHolderTableCell.identifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.separatorStyle = .none
        self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 24.0, right: 0.0)
        self.tableView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkInternetConection()
        uploadActivities()
        openMainViewController()
        
        self.coachMarksController.skipView?.isHidden = false
        //start Instaractions
        firstLaunchApp()
       
       let traning =  UserDefaults.standard.bool(forKey: "repidMain")
        
        if traning {
            self.coachMarksController.start(in: .window(over: self))
        }
       
        let mainScreenItem = items.first { (tableViewItem) -> Bool in
            tableViewItem is MainScreenItem
        } as? MainScreenItem
        guard mainScreenItem != nil else { return }
        
        Observable.zip(citizenApi.getUserBalance().catchErrorJustReturn(Balance(balance: -1)), healthProvider.getTodayStepCountObservable().catchErrorJustReturn(-1)).subscribe (onNext: { balance, steps in
            var stepsCountString = ""
            if steps >= 0 {
                stepsCountString = "\(Int(steps)) шагов"
            } else {
                stepsCountString = "? шагов"
            }
            
            mainScreenItem!.sectionLeft = stepsCountString
            mainScreenItem!.sectionRight = "\(balance.balance) д₽"
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
           
        }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return TableViewTypeFactory.cellForTableViewItem(tableView: tableView, item: items[indexPath.row])
    }
    
    func buttonDobrorublesTapped() {
        let webBalanceViewController = WebViewController()
        let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)!
        #if DEBUG
        webBalanceViewController.url = "https://dev.acitivzen.ru/statistics/?token=\(token)"
        #else
        //newWay
        webBalanceViewController.url = Constants.webViewPwa + "/history/?token=\(token)"
        //oldWay
       // webBalanceViewController.url = "https://statistics.acitizen.ru/?token=\(token)"
        #endif
        self.navigationController?.pushViewController(webBalanceViewController, animated: true)
    }
    func buttonStepsTapped() {
        let hkTypes = Set([HKObjectType.workoutType(),
                           HKObjectType.quantityType(forIdentifier: .stepCount)!,
                           HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                           HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!])
        
        healthStore.requestAuthorization(toShare: hkTypes, read: hkTypes) { (userWasShownPermissionView, error) in
            // Determine if the user saw the permission view
            if (userWasShownPermissionView) {
                if (self.healthStore.authorizationStatus(for: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!) == .sharingAuthorized) {
                    self.healthProvider.getMostRecentSample(for:HKObjectType.quantityType(forIdentifier: .stepCount)!) { (sample, erorr) in
                        if sample == nil {
                            DispatchQueue.main.async {
                                self.alertHealthView()
                              }
                            }
                          }
            } else {
                    DispatchQueue.main.async {
                        self.alertHealthView()
                      }
                   }
               } else {
                  DispatchQueue.main.async {
                       self.alertHealthView()
                   }
                   if let e = error {
                       print(e)
                   }
                }
            }
        }
    
   private func uploadActivities() {
        physicalActivityService.uploadLatestActivities { success in
            print(success)
        }
    }

    @objc func startRefreshing() {
        self.items.removeAll()
        self.tableView.reloadData()
        self.tableView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
        self.tableView.refreshControl?.beginRefreshing()
        uploadActivities()
        setupView()
    }
    
   private func stopRefreshing() {
        self.refreshControl.endRefreshing()
        self.tableView.contentInset = UIEdgeInsets.zero
        self.tableView.setContentOffset(.zero, animated: true)
    }
    
    private func setupView() {
        //  Get current hour        
        let currentHour: Int = Calendar.current.component(.hour, from: Date())
        //  Display specific greeting according to the current hour
        var greeting = ""
        switch(currentHour) {
        case 4..<12: greeting = "Доброе утро!"
        case 12..<17: greeting = "Добрый день!"
        case 17...23: greeting = "Добрый вечер!"
        default:
            greeting = "Доброй ночи!"
        }
        //  Display user's name along with the greeting
        //        let userName = UserDefaults.standard.string(forKey: Constants.userNameKeyUserDefaults) ?? "Username"
        //        userNameLabel.text = userName
        
        Observable.zip(citizenApi.getUserBalance().catchErrorJustReturn(Balance(balance: -1)), healthProvider.getTodayStepCountObservable().catchErrorJustReturn(-1)).subscribe (onNext: { balance, steps in
            var stepsCountString = ""
            if steps >= 0 {
                stepsCountString = "\(Int(steps)) шагов"
            } else {
                stepsCountString = "? шагов"
            }
            
            let mainScreenItem = MainScreenItem(title: greeting, sectionLeft: stepsCountString, sectionRight: "\(balance.balance) д₽")
               
            mainScreenItem.onSectionRightClicked = {
                self.buttonDobrorublesTapped()
            }
            mainScreenItem.onSectionLeftClickeds = {
                self.buttonStepsTapped()
            }
         
            
            self.items.append(mainScreenItem)
            
            let childVC = { () -> UIViewController in
                if WorkoutService.instance.isWorkoutRunning.get() {
                    return WorkoutViewController()
                } else {
                    let workoutController = WorkoutDescriptionViewController()
                    workoutController.delegate = self
                    return workoutController
                   // return WorkoutDescriptionViewController()
                }
            }()
            
            self.items.append(ViewControllerHolderItem(parentViewController: self, childViewController: childVC))
            
            let childDC = { () -> UIViewController in
             
                    return RatingViewController()
                
            }()
            
            self.items.append(ViewControllerHolderItem(parentViewController: self, childViewController: childDC))
            
            self.tableView.reloadData()
            self.getEvents()
            self.stopRefreshing()
        }, onError: { error in
            self.stopRefreshing()
            print(error)
        }).disposed(by: disposeBag)
    }

    private func getEvents() {
        citizenApi.getEvents().subscribe(onNext:{   events in
            let leftImageItems = events.list.map { event -> ElementLeftImagePreviewCollectionItem in
                
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
                
                let item = ElementLeftImagePreviewCollectionItem(image: event.images.first ?? "",
                                                                 preTitle: event.type ?? "",
                                                                 title: event.title ?? "",
                                                                 subTitle: readableStartDate,
                                                                 footer: event.place?.shortTitle ?? "")
                item.sender = {
                    self.performSegue(withIdentifier: "fromMainToEventVC", sender: event.id)
                }
                return item
            }
            
            //1
            var horizontalLeftItem = HorizontalLeftImageCollectionItem.init(title: "События", leftImageCollectionElements: leftImageItems)
            horizontalLeftItem.didTapShowAllClosure = {
                self.performSegue(withIdentifier: "fromMainToEventListVC", sender: nil)
            }
            
            self.items.append(horizontalLeftItem)
            self.tableView.reloadData()
            
            self.getProducts()
        }, onError: {  error in
            print(error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
    private func getProducts() {
        citizenApi.getProducts().subscribe(onNext: {   result in
            let listElementLeftImagePreview = result.list.map { (product) -> ElementLeftImagePreviewCollectionItem in
                let imagePreviewLink = product.preview ?? product.images.first ?? ""
                let element = ElementLeftImagePreviewCollectionItem.init(image: imagePreviewLink, preTitle: product.productType.title, title: product.title, subTitle: product.productInfo.first?.description ?? "", footer: product.partner.shortTitle)
                element.sender = {
                    self.performSegue(withIdentifier: "fromMainToProductVC", sender: product.id)
                }
                return element
            }
            
            var horizontalLeftItem = HorizontalLeftImageCollectionItem.init(title: "Квесты", leftImageCollectionElements: listElementLeftImagePreview)
            horizontalLeftItem.didTapShowAllClosure = {
                self.performSegue(withIdentifier: "fromMainToProductListVC", sender: nil)
            }
            self.items.append(horizontalLeftItem)
            self.tableView.reloadData()
        }, onError: {   error in
            print(error)
        }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "fromMainToEventVC": do {
            let destinationController = segue.destination as! EventViewController
            destinationController.eventId = sender as! Int
        }
        case "fromMainToProductVC": do {
            let destinationController = segue.destination as! ProductViewController
            destinationController.productId = sender as! Int
        }
        default:
            print("Unhandled segue")
        }
    }
   
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
    func alertHealthView() {
        let alert = UIAlertController(title: "Доступ к приложению Здоровье отключен", message: "Пожалуйста,  включите доступ в настройках приложения Здоровье", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        self.present(alert, animated: true)
    }
    func alertGeccoView() {
        let modalVC = StartTrainingUserViewController()
        modalVC.modalPresentationStyle = .overCurrentContext
        modalVC.delegate = self
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        self.tabBarController?.tabBar.backgroundColor = UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1)
        self.present(modalVC, animated: true) {
            print("start View")
        }

    }
    func firstLaunchApp() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if launchedBefore  {
        } else {
            alertGeccoView()
             UserDefaults.standard.set(true, forKey: "startTraning")
             UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
    func openMainViewController() {
    YMMYandexMetrica.reportEvent("Открытие Главного Экрана", onFailure: { (error) in
        print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    func getKeyForAppMetrica() {
        let _ = citizenApi.getKeyForAppMetrica().subscribe(onNext: { result in
            guard let value = result.value else { return }
            if value {
                UserDefaults.standard.set(true, forKey: Constants.appMetricaKey)
            } else {
                UserDefaults.standard.set(false, forKey: Constants.appMetricaKey)
            }
        }, onError: { error in
            print(error)
        }).disposed(by: disposeBag)
    }

}
