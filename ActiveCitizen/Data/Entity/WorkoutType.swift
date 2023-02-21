//
//  WorkoutType.swift
//  ActiveCitizen
//
//  Created by Sergey on 24.05.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import Foundation

// MARK: - WorkoutType
struct WorkoutType: Codable {
    let list: [List]
    let limit, offset, count: Int?
}

// MARK: - List
struct List: Codable {
    let id: Int
    let title: String
    let deleted: Bool
}
