//
//  ExNetworkError.swift
//  ActiveCitizen
//
//  Created by Sergey on 29.01.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import Foundation
import Alamofire

struct Connectivity {
  static let sharedInstance = NetworkReachabilityManager()!
  static var isConnectedToInternet: Bool {
      return self.sharedInstance.isReachable
    }
    static var isWiFi: Bool {
        return self.sharedInstance.isReachableOnEthernetOrWiFi
    }
    static var isCellular: Bool {
        return self.sharedInstance.isReachableOnCellular
    }
}
