//
//  HorizontalLeftImagePreviewCollectionTableViewCell.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 24.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class HorizontalLeftImagePreviewCollectionTableViewCell: AbstractTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var items = [AbstractCollectionViewItem]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return CollectionViewTypeFactory.cellForCollectionViewItem(collectionView: collectionView, indexPath: indexPath, item: items[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (items[indexPath.item].sender as? ()-> Void)?()
    }
    
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var viewButtonShowMore: UIView!
    var didTapShowMoreClosure: (() -> Void)?
    
    @IBOutlet weak var collectionView: UICollectionView?
    
    var item: HorizontalLeftImageCollectionItem? {
        didSet {
            guard let item = item else {
                return
            }
            self.items = item.leftImageCollectionElements
            self.collectionView?.reloadData()
            self.labelHeader.text = item.title
            self.didTapShowMoreClosure = item.didTapShowAllClosure
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapShowMore(_:)))
        tap.numberOfTapsRequired = 1
        self.viewButtonShowMore.addGestureRecognizer(tap)
        self.collectionView?.register(LeftImagePreviewCollectionViewCell.nib, forCellWithReuseIdentifier: LeftImagePreviewCollectionViewCell.identifier)
        self.collectionView?.contentInset = UIEdgeInsets.init(top: 0, left: 16.0, bottom: 0.0, right: 0.0)
    }
    
    @objc func didTapShowMore(_ sender: UITapGestureRecognizer? = nil) {
        didTapShowMoreClosure?()
    }
}
