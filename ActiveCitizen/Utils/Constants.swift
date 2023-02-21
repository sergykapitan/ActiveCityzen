//
//  Constants.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 03.12.2019.
//  Copyright © 2019 Novotorica. All rights reserved.
//

import Foundation
/// A class that contains application-wide constants
class Constants {
    #if DEBUG
    ///URL Address of testing api server
    static let apiEndpoint = "https://dev.acitivzen.ru/dev/api/v1"
    static let webViewPwa = "https://dev.acitivzen.ru/dev/api/v1"
    static let appMetricaKey = "https://dev.acitivzen.ru/dev/api/v2"
    #else
    ///URL Address of production api server
    static let apiEndpoint = "https://acitivzen.ru/api/v1"
    static let webViewPwa = "https://pwa.acitizen.ru"
    static let appMetricaKey = "https://acitizen.ru/api/v2"
    #endif
    
    /// Citizen API User access token
    static let accessTokenKeyUserDefaults = "ActiveCitizenApiAccessToken"
    static let userNameKeyUserDefaults = "AuthorizedUserName"
    static let dateLastActivityUploadUserDefaults = "DateLastActivityUpload"
    static let keyAppMetricaDefaults = "keyAppMetrica"

    static let hasUserEnteredQuizData = "HasUserEnteredQuizDataUserDefault"
    
    static let workoutRealmDatabaseSchemaVersion: UInt64 = 10
    static let urlDistrictConstant = "https://pwa.acitizen.ru/districts-rating"
    static let reuseID = "CollectionQRCodeImage"
    
    //Workout name key
    static let WALKING = "WALKING"
    static let RUNNING = "RUNNING"
    static let ON_BICYCLE = "ON_BICYCLE"
    static let SKATES = "SKATES"
    static let SKI = "SKI"
    static let WALK_IN_PLACE = "WALK_IN_PLACE"
    static let RUN_IN_PLACE = "RUN_IN_PLACE"
  
    
    
    
}
