//
//  AuthorizationRequest.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 05.12.2019.
//  Copyright © 2019 Novotorica. All rights reserved.
//

import Foundation
/// Entity for native Sign In With Apple authorization (iOS 13.0 and newer)
struct AuthorizationRequest: Codable {
    ///User's first name
    let firstName : String
    ///User's surname
    let lastName: String
    ///Apple Sign In Token
    let idToken: String
}
