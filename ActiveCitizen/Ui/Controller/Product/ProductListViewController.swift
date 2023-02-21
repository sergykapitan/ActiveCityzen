//
//  ProductListViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 15.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class ProductListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items = [AbstractTableViewItem]()
    
    @Inject var citizenApi: CitizenAPI
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return TableViewTypeFactory.cellForTableViewItem(tableView: tableView, item: items[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "fromProductListToProductVC", sender: items[indexPath.row].sender)
    }
    
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        tableView.register(ColoredFootersItemCell.nib, forCellReuseIdentifier: ColoredFootersItemCell.identifier)
        tableView.register(ElementLeftImagePreviewCell.nib, forCellReuseIdentifier: ElementLeftImagePreviewCell.identifier)
        
        self.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.reloadData()
        getProducts()
    }
    
    private func getProducts() {
        citizenApi.getProducts().subscribe(onNext: {   result in
            let tableViewProducts = result.list.map { (product) -> ElementLeftImagePreviewItem in
                let imagePreviewLink = product.preview ?? product.images.first ?? ""
                let element = ElementLeftImagePreviewItem.init(image: imagePreviewLink, preTitle: product.productType.title, title: product.title, subTitle: product.productInfo.first?.description ?? "", footer: product.partner.shortTitle)
                element.sender = product
                return element
            }
            self.items.append(contentsOf: tableViewProducts)
            self.tableView.reloadData()
        }, onError: {   error in
            print(error)
        }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromProductListToProductVC" {
            let destination = segue.destination as! ProductViewController
            destination.productId = (sender as! Product).id
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Sets navigation bar color to transparent
        self.navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // Restores navigation bar to default state
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
}
