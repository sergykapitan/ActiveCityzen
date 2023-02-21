//
//  DoubleDecodableResponseSerializer.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 15.10.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Alamofire

final class DoubleDecodableResponseSerializer<T: Decodable>: ResponseSerializer {
    
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        return decoder
    }()
    
    private let errorCode: Int
    
    init(errorCode: Int) {
        self.errorCode = errorCode
    }

    private lazy var successSerializer = DecodableResponseSerializer<T>(decoder: decoder)
    private lazy var errorSerializer = DecodableResponseSerializer<HttpErrorBody>(decoder: decoder)

    public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> Result<T, HttpErrorBody> {
        
        guard error == nil else { return .failure(HttpErrorBody(statusCode: 0, title: "", message: "")) }

        guard let response = response else { return .failure(HttpErrorBody(statusCode: 204, title: "", message: "Нет ответа от удаленного сервера")) }

        do {
            if response.statusCode >= 300 {
                let result = try errorSerializer.serialize(request: request, response: response, data: data, error: nil)
                return .failure(result)
            } else {
                let result = try successSerializer.serialize(request: request, response: response, data: data, error: nil)
                return .success(result)
            }
        } catch(let err) {
            print(err)
            return .failure((HttpErrorBody(statusCode: 0, title: "", message: "Неправильный ответ сервера")))
        }

    }

}
