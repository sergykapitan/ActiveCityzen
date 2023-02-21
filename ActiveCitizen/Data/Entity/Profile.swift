//
//  Profile.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 21.07.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation

struct Profile: Codable {
    let birthDate: String
    let height: Int
    let sex: Bool
    let weight: Int?
    let vendor: String?
    let model: String?
    let os: String?
}
