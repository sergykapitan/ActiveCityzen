//
//  QrCodeStatusResponse.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 07.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

struct QrCodeStatusResponse: Codable {
    let userId, date, key, status: String
    let amount: Int
    let invoiceTimestamp: Int?
}
