//
//  DobroOfferCategory.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 28.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

struct DobroOfferCategory: Codable  {
    var name, description: String
}

extension DobroOfferCategory: Hashable {
    static func == (lhs: DobroOfferCategory, rhs: DobroOfferCategory)-> Bool {
        return lhs.description == rhs.description && lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(description)
    }
}
