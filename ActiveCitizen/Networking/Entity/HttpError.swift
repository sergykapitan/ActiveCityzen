//
//  HttpError.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 09.12.2019.
//  Copyright © 2019 Novotorica. All rights reserved.
//

/// A enum that contains most frequent HTTP errors.
public enum HttpError: Int, Error {
    /// Equal to HTTP 401: Unauthorized
    case unautorized = 401
    /// Equal to  HTTP 403: Forbidden
    case forbidden = 403
    /// Equal to HTTP 404: Not Found
    case notFound = 404
    /// Equal to HTTP 500: Internal Server Error
    case internalServerError = 500
    /// Equal to HTTP 503: Service Unavailable
    case serviceUnavailable = 503
    /// Equal to HTTP 504: Gateway Timeout
    case gatewayTimeout = 504
    /// Unknown HTTP Error
    case unknown
}
