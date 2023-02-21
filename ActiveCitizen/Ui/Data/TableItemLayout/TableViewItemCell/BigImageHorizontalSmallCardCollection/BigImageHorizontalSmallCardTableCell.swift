//
//  BigImageHorizontalSmallCardCollectionCell.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 29.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class BigImageHorizontalSmallCardTableCell: AbstractTableViewCell,UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var imageViewBackground: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var labelChipText: UILabel!
    @IBOutlet weak var labelCarouselTitle: UILabel!
    @IBOutlet weak var labelCarouselActionTitle: UILabel!
    @IBOutlet weak var buttonCarouselAction: UIView!
    @IBOutlet weak var viewCarouselContainer: UIView!
    @IBOutlet weak var imageViewConstraintHeight: NSLayoutConstraint!
    
    var carouselItems = [AbstractCollectionViewItem]()
    @IBOutlet weak var collectionViewHorizonalItems: UICollectionView!
    @IBOutlet weak var collectionViewHorizontalConstraintHeight: NSLayoutConstraint!
    var didTapShowMoreClosure: (() -> Void)?
    
    
    var item: BigImageHorizontalSmallCardTableItem? {
        didSet {
            guard let item = item else {
                return
            }
            if let url = item.imageLink {
                self.imageViewBackground.kf.setImage(with: URL(string: url))
            }
            self.labelTitle.text = item.title
            self.labelSubtitle.text = item.subtitle
            
            if item.chipText != nil {
                self.labelChipText.text = item.chipText
            } else {
                self.labelChipText.isHidden = true
            }
            self.labelCarouselTitle.text = item.carouselTitle
            self.labelCarouselActionTitle.text = item.carouselActionButtonText
            self.didTapShowMoreClosure = item.didTapShowMoreClosure
            
            if item.carouselItems.isEmpty {
                self.viewCarouselContainer.isHidden = true
                self.imageViewConstraintHeight.constant = 180
                self.collectionViewHorizontalConstraintHeight.constant = 0
            } else {
                self.viewCarouselContainer.isHidden = false
                self.imageViewConstraintHeight.constant = 310
                self.collectionViewHorizontalConstraintHeight.constant = 84
                self.carouselItems = item.carouselItems
            }
            collectionViewHorizonalItems.reloadData()
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layoutIfNeeded()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = UIColor(hexString: "#f5f5f5")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapShowMore(_:)))
        tap.numberOfTapsRequired = 1
        self.buttonCarouselAction.addGestureRecognizer(tap)
   
        self.collectionViewHorizonalItems.delegate = self
        self.collectionViewHorizonalItems.dataSource = self
        self.collectionViewHorizonalItems.register(CroppedRightImageChipCollectionViewCell.nib, forCellWithReuseIdentifier: CroppedRightImageChipCollectionViewCell.identifier)
        self.collectionViewHorizonalItems.contentInset = .init(top: 0.0, left: 12.0, bottom: 0.0, right: 0.0)
        
        addGradientToImageView()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        CollectionViewTypeFactory.cellForCollectionViewItem(collectionView: collectionView, indexPath: indexPath, item: carouselItems[indexPath.item])
    }
    
    
    private func addGradientToImageView() {
        let foregroundGradientLayer = CAGradientLayer()
        foregroundGradientLayer.colors = [
          UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 0).cgColor,
          UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1).cgColor
        ]
        foregroundGradientLayer.locations = [0, 0.5]
        foregroundGradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
        foregroundGradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        foregroundGradientLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
        foregroundGradientLayer.bounds = imageViewBackground.bounds.insetBy(dx: -0.5*imageViewBackground.bounds.size.width, dy: -0.5*imageViewBackground.bounds.size.height)
        foregroundGradientLayer.position = imageViewBackground.center
        imageViewBackground.layer.addSublayer(foregroundGradientLayer)
    }
    
    override func prepareForReuse() {
        imageViewBackground.kf.cancelDownloadTask()
        imageViewBackground.image = nil
    }
    
    @objc func didTapShowMore(_ sender: UITapGestureRecognizer? = nil) {
        didTapShowMoreClosure?()
    }
}
