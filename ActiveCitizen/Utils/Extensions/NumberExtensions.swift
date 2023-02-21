//
//  NumberExtensions.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 17.06.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
