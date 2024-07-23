//
//  GiphyProvider.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/22.
//

import Foundation
import Moya

public enum GiphyError: Error {
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

final class GiphyProvider {
    private static let provider = MoyaProvider<Giphy>(
        plugins: [NetworkLoggerPlugin()]
    )
    
    static func request<T: Codable>(target: Giphy) async -> Result<T, GiphyError> {
        let response = await provider.requestAsync(target: target)
        switch response {
        case .success(let success):
            if let response = try? JSONDecoder().decode(T.self, from: success.data) {
                return .success(response)
            } else {
                return .failure(.jsonDecodeError)
            }
        case .failure(let failure):
            if let failureResponse = failure.response {
                switch failureResponse.statusCode {
                case 400:
                    return .failure(.badRequest)
                case 401:
                    return .failure(.unAuthorized)
                case 403:
                    return .failure(.forbidden)
                case 404:
                    return .failure(.notFound)
                case 414:
                    return .failure(.uriTooLong)
                case 429:
                    return .failure(.tooManyRequests)
                case 400...499:
                    return .failure(.clientError)
                case 500...599:
                    return .failure(.serverError)
                default:
                    return .failure(.unknownError(failure))
                }
            }
            return .failure(.unknownError(failure))
        }
    }
}

extension MoyaProvider {
    func requestAsync(target: Target) async -> Result<Response, MoyaError> {
        await withCheckedContinuation { continuation in
            self.request(target) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
