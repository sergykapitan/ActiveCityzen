//
//  DobromarketOfferViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 25.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class DobromarketOfferViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonPurchase: UIButton!
    
    @Inject var citizenApi: CitizenAPI
    
    var items = [AbstractTableViewItem]()
    var offerId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        
        if let rootVC = navigationController?.viewControllers.first {
            navigationController?.viewControllers = [rootVC, self]
        }
        
        buttonPurchase.isHidden = true
        tableView.estimatedRowHeight = 40
        self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 24.0, right: 0.0)
        self.tableView.contentInsetAdjustmentBehavior = .never
        self.tableView.register(NarrowImageTableViewCell.nib, forCellReuseIdentifier: NarrowImageTableViewCell.identifier)
        self.tableView.register(TitleBadgeChipFooterTableViewCell.nib, forCellReuseIdentifier: TitleBadgeChipFooterTableViewCell.identifier)
        self.tableView.register(TextBoxTableViewCell.nib, forCellReuseIdentifier: TextBoxTableViewCell.identifier)
        
        if let offerId = offerId {
            getDobrofferById(id: offerId)
        }
        
        self.navigationItem.backButtonTitle = " "
        self.buttonPurchase.addTarget(self, action: #selector(purchaseProduct), for: .touchUpInside)
    }
    
    @objc func purchaseProduct() {
        self.buttonPurchase.isEnabled = false
        citizenApi.purchaseDobroOfferById(id: offerId!)
            .subscribe(onNext: { dobroOrder in
                self.displayPromocode(promocode: dobroOrder.coupon, id: dobroOrder.orderId)
                self.buttonPurchase.isEnabled = true
            },
            onError: {   error in
                self.buttonPurchase.isEnabled = true
                print(error)
            }).disposed(by: disposeBag)
    }
    
    func displayPromocode(promocode: String, id: Int) {
        let promocodeVC = TitlePromocodeDescriptionViewController()
        promocodeVC.header = "Готово!"
        promocodeVC.promocodeHeader = "Промокод"
        promocodeVC.promocode = promocode
        promocodeVC.promocodeFooter = "Чтобы воспользоваться купоном, покажите его из мобильного приложения сотруднику на кассе. Просим предварительно связаться с партнером."
        promocodeVC.buttonText = "Прочитать QR-код на кассе"
        promocodeVC.buttonOnClick = {
            promocodeVC.dismiss(animated: true, completion: nil)
            
            let qrCodeScanController = self.storyboard?.instantiateViewController(withIdentifier: "QrCodeScanViewController") as! QrCodeScanViewController
            qrCodeScanController.dobroOrderId = id
            self.navigationController?.pushViewController(qrCodeScanController, animated: true)
        }
        promocodeVC.modalPresentationStyle = .overCurrentContext
        self.present(promocodeVC, animated: true, completion: nil)
    }
    
    private func getDobrofferById(id: Int) {
        citizenApi.getDobroOfferById(id: id).zip(with: citizenApi.getUserBalance(), resultSelector: { (dobroOffer, balance) -> (DobroOffer, Balance) in
            return (dobroOffer, balance)
        })
        .subscribe (onNext: { dobroOffer, balance  in
            self.buttonPurchase.setTitle("Купить за \(dobroOffer.price) д₽", for: .normal)
            if balance.balance < dobroOffer.price {
                self.buttonPurchase.isEnabled = false
                self.buttonPurchase.alpha = 0.6
            } else {
                self.buttonPurchase.isEnabled = true
                self.buttonPurchase.alpha = 1.0
            }
            self.buttonPurchase.isHidden = false
            var preTitle = ""
            dobroOffer.categories.enumerated().forEach { index, dobroOfferCategory in
                preTitle += dobroOfferCategory.description
                if dobroOffer.categories.count - 1 != index {
                    preTitle += ", "
                }
            }
            
            self.items.append(NarrowImageItem(imageLink: dobroOffer.imageUrl))
            self.items.append(TitleBadgeChipFooterItem.init(badgeImageLink: dobroOffer.logoUrl, title: dobroOffer.header, header: preTitle, chipText: "\(dobroOffer.price) д₽", footer: "Осталось: \(dobroOffer.inStock)"))
            self.items.append(TextBoxItem.init(title: "", body: dobroOffer.description))
            self.tableView.reloadData()
        }, onError: { error in
            print("error")
        }).disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return TableViewTypeFactory.cellForTableViewItem(tableView: tableView, item: items[indexPath.row])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        self.navigationController?.navigationBar.barStyle = .black
        // Make the navigation bar background clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}
