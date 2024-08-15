//
//  PayProvider.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/08/08.
//

import Foundation
import Moya

final class PayProvider {
    private static let provider = MoyaProvider<PayAPI>(
        plugins: [NetworkLoggerPlugin()]
    )
    
    static func request<T: Codable>(target: PayAPI) async -> Result<T, PayError> {
        let response = await provider.requestAsync(target: target)
        switch response {
        case .success(let success):
            if let response = try? JSONDecoder().decode(T.self, from: success.data) {
                return .success(response)
            } else {
                return .failure(.jsonDecodeError)
            }
        case .failure(let failure):
            print("jaebi failure: \(String(data: failure.response?.data ?? Data(), encoding: .utf8) ?? "")")
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
