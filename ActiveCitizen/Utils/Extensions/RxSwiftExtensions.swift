//
//  RxSwiftExtensions.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 05.12.2019.
//  Copyright © 2019 Novotorica. All rights reserved.
//

import Foundation

import RxSwift
import Alamofire

public extension AFDataResponse {
    func mapDataToObserver<T: Codable>(observer: AnyObserver<T>) {
        switch self.result {
        case .success:
            do {
                let item = try JSONDecoder().decode(T.self, from: self.data!)
                observer.onNext(item)
            } catch {
                observer.onError(error)
            }
        case .failure(let error):
            debugPrintHttpRequestResponse()
            if let statusCode = self.response?.statusCode,
                let reason = HttpError(rawValue: statusCode)
            {
                observer.onError(reason)
            }
            observer.onError(error)
        }
    }
    
    func mapDataToResultErrorObserver<T: Codable>(observer: AnyObserver<T>) {
//        let s = DoubleDecodableResponseSerializer.init(errorCode: 0)
        
    }
    
    func debugPrintHttpRequestResponse() {
        #if DEBUG
        if let httpBody = self.request?.httpBody {
            let json = String(data: httpBody, encoding: String.Encoding.utf8)
            print("Request body: \(json ?? "Empty")")
        } else { print("request is nil") }
        if let data = self.data {
            let json = String(data: data, encoding: String.Encoding.utf8)
            print("Response body: \(json ?? "Empty")")
        }
        if let statusCode = self.response?.statusCode,
            let reason = HttpError(rawValue: statusCode)
        {
            print(reason)
        }
        #endif
    }
}

extension DataRequest {

    /// Decodes the response to a type `T` or` `.
    ///
    /// NB: The serializer used `TwoDeodableResponseSerializer` doesn't throw though Alamofire
    /// response serializer expects to receive a `DataResponse`. All errors/failures are converted to an `APIError`.
    ///
    /// - Parameters:
    ///   - t: Type to decode to
    ///   - queue: `DispatchQueue` to dispatch `completionHandler`
    ///   - errorCode: code to signal error when to fetch `APIError`
    ///   - completionHandler: Handler called on completion
    @discardableResult func responseDecodable<T: Decodable>(queue: DispatchQueue = DispatchQueue.global(qos: .userInitiated), of t: T.Type, errorCode: Int, completionHandler: @escaping (Result<T, HttpErrorBody>) -> Void) -> Self {
        return response(queue: .main, responseSerializer: DoubleDecodableResponseSerializer<T>(errorCode: errorCode)) { response in
            switch response.result {
            case .success(let result):
                completionHandler(result)
            case .failure(let error):
                
                completionHandler(.failure(HttpErrorBody.init(statusCode: -1, title: nil, message: "")))
            }
        }
    }
}
