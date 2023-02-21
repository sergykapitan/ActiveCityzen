//
//  ListResponse.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 09.12.2019.
//  Copyright © 2019 Novotorica. All rights reserved.
//

class ListResponse<T: Codable>: Codable {
    var list: Array<T>
    var count: Int?
    var limit: Int?
    var offset: Int?
}
