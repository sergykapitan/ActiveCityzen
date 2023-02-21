//
//  HttpErrorBody.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 15.10.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

struct HttpErrorBody: Error, Codable {
    let statusCode: Int
    let title: String?
    let message: String
}
