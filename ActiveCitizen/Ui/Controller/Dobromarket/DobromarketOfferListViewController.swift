//
//  DobromarketOfferListViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 25.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import RxSwift
import MaterialComponents
import MaterialComponents.MaterialTabs
import MaterialComponents.MaterialTabs_ColorThemer
import YandexMobileMetrica

class DobromarketOfferListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, MDCTabBarDelegate {
    @IBOutlet weak var userBalanceBackground: UIView!
    @IBOutlet weak var labelUserBalance: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var categories: [Int: DobroOfferCategory] = [:]
    
    @Inject var citizenApi: CitizenAPI
    @IBOutlet weak var tabBar: MDCTabBar!
    
    var items = [AbstractTableViewItem]()
    
    
    //MARK: - LifiCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.contentInset = UIEdgeInsets(top: 24.0, left: 0.0, bottom: 24.0, right: 0.0)
        tableView.contentInsetAdjustmentBehavior = .never
        userBalanceBackground.clipsToBounds = true
        userBalanceBackground.layer.cornerRadius = 10
        userBalanceBackground.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        getDobroOfferCategories()
        tabBar.delegate = self
        tabBar.enableRippleBehavior = true
        tabBar.rippleColor = UIColor(hexString: "#00000000")
        tabBar.tintColor = UIColor(hexString: "#11A8EA")
        tabBar.unselectedItemTintColor = UIColor(hexString: "#424242")
        tabBar.itemAppearance = .titles
        tabBar.selectionIndicatorTemplate = CustomTabViewIndicator()
        tabBar.displaysUppercaseTitles = false
        tabBar.selectedItemTitleFont = UIFont.systemFont(ofSize: 14)
        tabBar.unselectedItemTitleFont = UIFont.systemFont(ofSize: 14)
        tabBar.sizeToFit()
        if let indicator = tabBar.allSubviews.first(where: { view in
            NSStringFromClass(type(of: view.self)) == "MDCTabBarIndicatorView"
        }) {
            indicator.layer.zPosition = -1
        }
        
        tableView.register(BigImageTitleBadgeTableViewCell.nib, forCellReuseIdentifier: BigImageTitleBadgeTableViewCell.identifier)
        tableView.reloadData()
        getUserBalance()
        getDobroOffers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkInternetConection()
        openDobromarketOfferListViewController()
    }
    //MARK: - getDobroOfferCategories
    private func getDobroOfferCategories() {
        citizenApi.getDobroOfferCategories().map({ (dobroOfferCategories) -> Array<UITabBarItem> in
            return dobroOfferCategories.list.map { (dobroOfferCategory) -> UITabBarItem in
                self.categories[dobroOfferCategory.hashValue] = dobroOfferCategory
                return UITabBarItem.init(title: dobroOfferCategory.description, image: nil, tag: dobroOfferCategory.hashValue)
            }
        })
        .subscribe(onNext: { (dobroOfferTabBars) in
            self.categories[101] = DobroOfferCategory(name: "", description: "Все")
            self.tabBar.items.append(UITabBarItem(title: "Все", image: nil, tag: 101))
            self.tabBar.items.append(contentsOf: dobroOfferTabBars)
            
            
        }, onError: { error in
            print(error)
        })
    }
    
    
    func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
        guard let category = categories[item.tag] else { return }
        getDobroOffers(category: category.name)
    }
    //MARK: - getDobroOffers
    func getDobroOffers(category : String = "") {
        var getDobroOffersObservable: Observable<ListResponse<DobroOffer>>? = nil
        if category.isEmpty {
            getDobroOffersObservable = citizenApi.getDobroOffers()
        } else {
            getDobroOffersObservable = citizenApi.getDobroOffersByCategory(category: category)
        }
        
        getDobroOffersObservable!.subscribe(onNext: { listResponse in
                self.items.removeAll()
                let badgeItems = listResponse.list.map { (dobroOffer) -> BadgeImageTitleItem in
                    
                    var preTitle = ""
                    dobroOffer.categories.enumerated().forEach { index, dobroOfferCategory in
                        preTitle += dobroOfferCategory.description
                        if dobroOffer.categories.count - 1 != index {
                            preTitle += ", "
                        }
                    }
                    let badgeTitleItem = BadgeImageTitleItem.init(imageViewHeaderLink:dobroOffer.imageUrl,
                                                      imageViewBadgeLink: dobroOffer.logoUrl,
                                                      preTitle: preTitle,title: dobroOffer.header,
                                                      chipText: "\(dobroOffer.price) д₽",
                                                      footer: "Осталось: \(dobroOffer.inStock)")
                    badgeTitleItem.sender = dobroOffer.offerId
                    return badgeTitleItem
                }
                self.items.append(contentsOf: badgeItems)
                self.tableView.reloadData()
            }, onError: { error in
                print(error)
            }).disposed(by: disposeBag)
    }
    
    //MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "fromDobromarketOfferListToDobroOfferVC", sender: items[indexPath.row].sender)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return TableViewTypeFactory.cellForTableViewItem(tableView: tableView, item: items[indexPath.row])
    }
    //MARK: - getUserBalance
    private func getUserBalance() {
        citizenApi.getUserBalance().subscribe(onNext: {[weak self] result in
            self?.labelUserBalance.text = "\(result.balance) д₽"
        }, onError: {   error in
            print(error)
        }).disposed(by: disposeBag)
    }
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromDobromarketOfferListToDobroOfferVC" {
            let destination = segue.destination as! DobromarketOfferViewController
            destination.offerId = sender as? Int
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
    func openDobromarketOfferListViewController() {
    YMMYandexMetrica.reportEvent("Открытие Добромаркета", onFailure: { (error) in
        print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
