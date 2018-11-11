//
//  TraktError.swift
//  CoreTraktTV
//
//  Created by Adolfo Vera Blasco on 28/5/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

public enum TraktError: Int
{
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case methodNotFound = 405
    case conflict = 409
    case preconditionFailed = 412
    case unprocessibleEntity = 422
    case rateLimitExceeded = 429
    case serverError = 500
    case serverOverloaded = 503
    case serverUnavailable = 504
    case cloudflareUnknownError = 520
    case serverIsDown = 521
    case connectionTimedOut = 522

    /**

    */
    internal init(httpCode code: Int)
    {
        if let error = TraktError(rawValue: code)
        {
            self = error
        }
        else
        {
            self = TraktError.badRequest
        }
    }
}