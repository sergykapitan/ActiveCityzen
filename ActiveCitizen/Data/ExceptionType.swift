//
//  Exception.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 14.01.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation

enum ExceptionType: Error {
    case runtime(message: String)
    case illegalArgument(message: String)
    case security(message: String)
    case unknown(message: String)
}
