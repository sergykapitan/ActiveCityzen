//
//  ProductViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 17.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import RxSwift

class ProductViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var buttonPurchaseProduct: UIButton!
    @IBOutlet weak var tableViewToSafeAreBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomToButtonPurchaseProductTopConstraint: NSLayoutConstraint!
    var items = [AbstractTableViewItem]()
    
    @IBOutlet weak var progressContainerBottomToSafeArea: NSLayoutConstraint!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelProgressTitle: UILabel!
    @IBOutlet weak var labelProgressStatus: UILabel!
    
    @IBOutlet weak var progressViewContainer: UIView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return TableViewTypeFactory.cellForTableViewItem(tableView: tableView, item: items[indexPath.row])
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @Inject
    var citizenApi: CitizenAPI
    
    var productId: Int = -1
    var productPurchasedTimestamp: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.separatorStyle = .none
        
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 2)
        self.buttonPurchaseProduct.isHidden = true
        self.progressViewContainer.isHidden = true
        
        self.tableViewToSafeAreBottomConstraint.isActive = true
        self.tableViewBottomToButtonPurchaseProductTopConstraint.isActive = false
        
        tableView.register(BigImageTitleFooterTableViewCell.nib, forCellReuseIdentifier: BigImageTitleFooterTableViewCell.identifier)
        tableView.register(TextBoxTableViewCell.nib, forCellReuseIdentifier: TextBoxTableViewCell.identifier)
        tableView.register(SingleButtonTableViewCell.nib, forCellReuseIdentifier: SingleButtonTableViewCell.identifier)
        
        // Disables insets for uitableview top item
        self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 64.0, right: 0.0)
        self.tableView.contentInsetAdjustmentBehavior = .never
        getProductById(id: productId)
        
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        }
        else {
            return .default
        }
    }
    
    private func getProductById(id: Int) {
        citizenApi.getProductById(id: id).subscribe(onNext: { product in
            self.items.append(BigImageTitleFooterItem(title: product.title, footer: product.partner.shortTitle, imageLink:product.images.first ?? ""))
            self.items.append(TextBoxItem(title: "", body: product.description))
            
            if product.rules != nil && !product.rules!.isEmpty {
                self.items.append(TextBoxItem(title: "Условия получения", body: "\(product.rules!)"))
            }
            if product.additional != nil && !product.additional!.isEmpty {
                self.items.append(TextBoxItem(title: "Дополнительно", body: "\(product.additional!)"))
            }
            
            if !product.url.isEmpty {
                var buttonUrl = SingleButtonItem(title: "Сайт партнера")
                buttonUrl.sender = Executable(block: {
                    UIApplication.shared.open(URL.init(string: product.url)!, options: [:], completionHandler: nil)
                })
                self.items.append(buttonUrl)
            }
            
            self.tableView.reloadData()
            self.checkProductAvailability(id: self.productId)
        }, onError: { error in
            print(error)
        }).disposed(by: disposeBag)
    }
    
    private func checkProductAvailability(id: Int) {
        self.buttonPurchaseProduct.removeTarget(nil, action: nil, for: .allEvents)
        citizenApi.checkProductIsAvailableForPurchase(id: id).subscribe(onNext: { result in
            guard let productAvailability = result.list.first else { return }
            if productAvailability.purchaseTimestamp == nil && (productAvailability.currentDistance >= productAvailability.targetDistance) {
                self.buttonPurchaseProduct.setTitle("Получить промокод", for: .normal)
                self.buttonPurchaseProduct.isHidden = false
                self.buttonPurchaseProduct.isEnabled = true
                self.buttonPurchaseProduct.addTarget(self, action: #selector(self.purchasePromocode), for: .touchUpInside)
                
                self.tableViewToSafeAreBottomConstraint.isActive = false
                self.progressContainerBottomToSafeArea.isActive = false
                self.progressViewContainer.isHidden = true
                self.tableViewBottomToButtonPurchaseProductTopConstraint.isActive = true
                
            } else if productAvailability.purchaseTimestamp != nil {
                self.productPurchasedTimestamp = productAvailability.purchaseTimestamp!
                self.setButtonHasPurchasedTimestamp()
            } else {
                let progressKms = Double(productAvailability.targetDistance - productAvailability.currentDistance) / 1000
                let progressPercentage: Float = {
                    if productAvailability.currentDistance == 0 {
                       return 0.0
                    } else {
                        return  Float(productAvailability.currentDistance) / Float(productAvailability.targetDistance)
                    }
                }()
                self.tableViewToSafeAreBottomConstraint.isActive = false
                self.progressViewContainer.isHidden = false
                self.progressContainerBottomToSafeArea.isActive = true
                self.tableViewBottomToButtonPurchaseProductTopConstraint.isActive = false
                switch(ActivityType(rawValue: productAvailability.activityTypeId)) {
                case .ON_BICYCLE: do {
                    self.labelProgressTitle.text = "Тебе осталось проехать"
                }
                case .WALKING: do {
                    self.labelProgressTitle.text = "Тебе осталось пройти"
                }
                case .RUNNING, .SKATES, .SKI: do {
                    self.labelProgressTitle.text = "Тебе осталось пробежать"
                }
                case .SWIMMING: do {
                    self.labelProgressTitle.text = "Тебе осталось проплыть"
                }
                default: print("Unknown ActivityType id")
                }
                self.labelProgressStatus.text = "\(progressKms.rounded(toPlaces: 1)) км"
                self.progressView.setProgress(Float(progressPercentage), animated: true)
                
            }
        }, onError: {  error in
            print(error)
        }).disposed(by: disposeBag)
    }
    
    @objc func purchasePromocode() {
        buttonPurchaseProduct.isEnabled = false
        self.buttonPurchaseProduct.isHidden = true
        citizenApi.getProductById(id: productId).filter({ (product: Product) -> Bool in
            product.productInfo.first != nil
        }).map({ (product:Product) -> ProductPurchaseRequest in
            ProductPurchaseRequest(productInfoId: product.productInfo.first!.id)
        }).flatMap { (productPurchaseRequest: ProductPurchaseRequest) -> Observable<ProductPurchaseStatus> in
            self.citizenApi.purchaseProductInfo(productPurchaseRequest: productPurchaseRequest)
        }.flatMap({ (productPurchaseResponse) -> Observable<ProductPurchaseStatus> in
             self.citizenApi.getPurchaseByOrderId(orderId: productPurchaseResponse.orderId)
                .debug("CitezenApi")
                .delay(.milliseconds(375), scheduler: MainScheduler.instance)
                .retry(4)
                .filter { (productPurchaseStatus) -> Bool in
                    // Отфильтровать
                    productPurchaseStatus.status == "DONE" ||  productPurchaseStatus.status == "ERROR"||productPurchaseStatus.status == "PERFORMED"
                }
        }).flatMap { (productPurchaseStatus) -> Observable<Purchase> in
            if productPurchaseStatus.status == "DONE"
            {
                self.setButtonHasPurchasedTimestamp()
                return self.citizenApi.getPurchaseByTimestamp(timestamp:(productPurchaseStatus.purchasesTimestamps?.first)! )
              
            } else if productPurchaseStatus.status == "ERROR" {
                throw ExceptionType.illegalArgument(message: "Unable to purchase productInfo: Status ERROR")
            } else {
                throw ExceptionType.illegalArgument(message: "Illegal Purchase status")
            }
        }
        .subscribe(onNext: { result in
            self.setButtonHasPurchasedTimestamp()
            self.presentPromocode()
            self.productPurchasedTimestamp = result.invoiceTimestamp
        }, onError: { error in
            print(error)
            self.checkProductAvailability(id: self.productId)
        }).disposed(by: disposeBag)
    }
    
   private func setButtonHasPurchasedTimestamp() {
        
        self.buttonPurchaseProduct.removeTarget(nil, action: nil, for: .allEvents)
        self.buttonPurchaseProduct.addTarget(self, action:
                                                #selector(self.presentPromocode), for: .touchUpInside)
        self.buttonPurchaseProduct.setTitle("Показать промокод", for: .normal)
        self.buttonPurchaseProduct.isHidden = false
        self.buttonPurchaseProduct.isEnabled = true
        
        self.tableViewToSafeAreBottomConstraint.isActive = false
        self.progressContainerBottomToSafeArea.isActive = false
        self.progressViewContainer.isHidden = true
        self.tableViewBottomToButtonPurchaseProductTopConstraint.isActive = true
    }
    
    @objc func presentPromocode() {
        self.citizenApi.getPurchaseByTimestamp(timestamp: productPurchasedTimestamp).subscribe(onNext:{  result in
            let vc = PromocodeModalViewController()
            vc.promocode = result.promocode
            self.present(vc, animated: true, completion: nil)
        }, onError: {error in
            print(error)
        }).disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
}
