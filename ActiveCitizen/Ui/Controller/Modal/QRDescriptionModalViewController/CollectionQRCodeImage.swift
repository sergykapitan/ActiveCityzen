//
//  CollectionQRCodeImage.swift
//  ActiveCitizen
//
//  Created by Sergey on 25.03.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import Foundation
import UIKit

final class CollectionQRCodeImage: UICollectionViewCell {

    //MARK: - UI
    private let photoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
       // imageView.layer.cornerRadius = 6
        imageView.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()
   

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImage.image = nil
    }
    
    private func initUI() {
        clipsToBounds = true
        backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
        contentView.addSubview(photoImage)
    }
    
    private func initLayout() {
        photoImage.anchor(top: contentView.topAnchor,
                          left: contentView.leftAnchor,
                          bottom: contentView.bottomAnchor,
                          paddingTop: 5,
                          paddingLeft: 5,
                          paddingBottom: 5,
                          width: contentView.frame.width ,
                          height: contentView.frame.height)
   
    }
    
    //MARK: - Methods
    func configureCell( url: String) {
        photoImage.kf.setImage(with: URL(string: url ))

    }
  
}


