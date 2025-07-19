//
//  Bundle+.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 7/19/25.
//

import Foundation

extension Bundle {
    var apiKey: String {
        object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    }
}
