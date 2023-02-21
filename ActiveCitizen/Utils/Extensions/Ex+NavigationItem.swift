//
//  Ex+NavigationItem.swift
//  ActiveCitizen
//
//  Created by Sergey on 05.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationItem {
    func addSettingButtonOnRight(){
        let button = UIButton(type: .custom)
    button.setTitle("setting", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
    button.layer.cornerRadius = 5
    button.backgroundColor = .gray
    button.frame = CGRect(x: 0, y: 0, width: 100, height: 25)
        button.addTarget(self, action: #selector(gotSettingPage), for: UIControl.Event.touchUpInside)
    let barButton = UIBarButtonItem(customView: button)

        self.rightBarButtonItem = barButton
    }

    @objc func gotSettingPage(){

    }
}
