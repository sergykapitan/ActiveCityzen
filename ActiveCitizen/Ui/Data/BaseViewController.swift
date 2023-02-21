//
//  BaseViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 15.10.2019.
//  Copyright © 2019 Novotorica. All rights reserved.
//

import Foundation
import RxSwift

/// Base class for UIViewController
class BaseViewController: UIViewController {
    /// A dispose bag to manage disposable subscriptions.
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(hexString: "#F5F5F5")
    }
}
