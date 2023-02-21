//
//  UserProfile.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 12.12.2019.
//  Copyright © 2019 Novotorica. All rights reserved.
//

struct UserProfile: Codable {
    let userId, firstName, lastName: String
    let sex: Bool?
    let height, weight: Int?
    let email, birthDate: String
}
