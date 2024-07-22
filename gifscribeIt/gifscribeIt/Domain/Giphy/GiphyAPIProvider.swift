//
//  GiphyAPIProvider.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/22.
//

import Foundation

struct GiphyAPIProvider {
    public func request(endpoint: String) async throws -> Int {
        do {
            guard var url = URL(string: endpoint) else {
                throw NetworkError.invalidURL
            }
            
            let queryParametersDictionary = [
                "api_key": "mUjOyCy2TcvgUSYT10kLOSEssPcsTpCB",
                "rating": "g"
            ]
            
            let urlQueryItems = queryParametersDictionary.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
            
            url.append(queryItems: urlQueryItems)
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            print("jaebi: \(data)")
            return 200
        } catch {
            return -1
        }
    }
}

enum NetworkError: Error {
    case invalidURL
}

private extension Data {
    
}
