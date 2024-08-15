//
//  PayError.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/08/08.
//

import Foundation
import Moya

enum PayError: Error {
    case badRequest
    case unAuthorized
    case forbidden
    case notFound
    case uriTooLong
    case tooManyRequests
    case clientError
    case serverError
    case unknownError(MoyaError)
    case jsonDecodeError
    case parseError
    case none
}
