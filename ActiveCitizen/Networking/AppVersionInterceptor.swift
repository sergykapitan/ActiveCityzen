//
//  AppVersionInterceptor.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 24.11.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Alamofire

class AppVersionInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Swift.Result<URLRequest, Error>) -> Void) {
        
        var adaptedRequest = urlRequest
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let buildVersionNumber: String? = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
       
        let appVersionName = "\(appVersion ?? "") - \(buildVersionNumber ?? "")"
        
        adaptedRequest.addValue(appVersionName, forHTTPHeaderField: "client-version")
        completion(.success(adaptedRequest))
    }
}
//"client_version"
