//
//  Giphy.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/23.
//

import Foundation
import Moya

enum Giphy {
    case searchGifs(keyword: String)
}

extension Giphy: TargetType {
    var baseURL: URL { URL(string: "https://api.giphy.com")! }
    
    var path: String {
        switch self {
        case .searchGifs:
            return "/v1/gifs/search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchGifs:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .searchGifs(let keyword):
            return .requestParameters(
                parameters: [
                    "q": keyword, 
                    "limit": "25",
                    "offset": "0",
                    "rating": "g",
                    "lang": "en",
                    "bundle": "messaging_non_clips",
                    "api_key": "__input__"
                ],
                encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var validationType: ValidationType {
        switch self {
        case .searchGifs:
            return .successCodes
        }
    }
}
