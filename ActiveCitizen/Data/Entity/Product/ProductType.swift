//
//  ProductType.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 17.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation

struct ProductType: Codable {
    let id: Int
    let title, measure, lot: String
}
