//
//  PhoneNumberConfirmationSmsStatus.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 08.07.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation
struct PhoneNumberConfirmationSmsStatus: Codable {
    let isSend: Bool
    let ttl: Int
    let dailyCount: Int
    let isBanned: Bool
    let isVeryOften: Bool
}
