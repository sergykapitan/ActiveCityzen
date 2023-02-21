//
//  QrCodeUploadRequest.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 05.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation

struct QrCodeUploadRequest: Codable {
    let location: Location
    let key: String
}
