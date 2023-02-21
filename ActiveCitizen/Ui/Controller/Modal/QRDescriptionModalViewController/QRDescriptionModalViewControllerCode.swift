//
//  QRDescriptionModalViewControllerCode.swift
//  ActiveCitizen
//
//  Created by Sergey on 23.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import UIKit
import Kingfisher

final class QRDescriptionModalViewControllerCode: UIView {
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let viewQRCode: DescriptionViewCode = {
        let view = DescriptionViewCode()
        view.cornerRadius = 4
        return view
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
        cardView.addSubview(viewQRCode)
 
        viewQRCode.centerX(inView: cardView)
        viewQRCode.centerY(inView: cardView)
        viewQRCode.anchor(width: 296, height: 312)
    }
    func setUI(description: String?) {
        viewQRCode.descriptionQRCode.text = description
    }
}
