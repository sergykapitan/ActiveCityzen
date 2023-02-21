//
//  DescriptionViewCode.swift
//  ActiveCitizen
//
//  Created by Sergey on 23.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import UIKit
import Kingfisher

final class DescriptionViewCode: UIView {
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.cornerRadius = 4
        return view
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Как найти QR-код?"
        return label
    }()
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "iconCrossGray"), for: .normal)
        return button
    }()
    var imageQRCode: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    lazy var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CollectionQRCodeImage.self, forCellWithReuseIdentifier: Constants.reuseID)
        return collectionView
    }()
    let descriptionQRCode: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Описание места расположения QR"
        return label
    }()
    let scrollDescription: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func initUI() {
       addSubview(cardView)
        cardView.fillSuperview()
        cardView.addSubview(titleLabel)
        titleLabel.anchor(top: cardView.topAnchor,
                          left: cardView.leftAnchor,
                          paddingTop: 5, paddingLeft: 15)
        cardView.addSubview(closeButton)
        closeButton.anchor(top: cardView.topAnchor,
                           right: cardView.rightAnchor,
                           paddingTop: 5, paddingRight: 15, width: 20, height: 20)
        cardView.addSubview(collectionView)
        collectionView.anchor(top: titleLabel.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 5, paddingLeft: 15, paddingRight: 15, height: 132)
        cardView.addSubview(scrollDescription)
        scrollDescription.anchor(top: collectionView.bottomAnchor,
                                 left: cardView.leftAnchor, right: cardView.rightAnchor,bottom: cardView.bottomAnchor,
                                 paddingTop: 5, paddingLeft: 15, paddingRight: 15,paddingBottom: 5)
        scrollDescription.contentSize = descriptionQRCode.bounds.size
        scrollDescription.addSubview(descriptionQRCode)
        descriptionQRCode.anchor(top: scrollDescription.topAnchor,
                                 left: cardView.leftAnchor, right: cardView.rightAnchor,bottom: scrollDescription.bottomAnchor,
                                 paddingTop: 5, paddingLeft: 15, paddingRight: 15,paddingBottom: 5)

    }
}
