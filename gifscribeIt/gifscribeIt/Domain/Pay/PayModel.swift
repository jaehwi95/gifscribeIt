//
//  PayModel.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/08/08.
//

import Foundation

struct PayModel: Equatable {
    let tid: String
    let nextRedirectAppURL: String
    let nextRedirectMobileURL: String
    let nextRedirectPCURL: String
    let iosAppScheme: String
    let createdAt: String
    
    init(
        tid: String,
        nextRedirectAppURL: String,
        nextRedirectMobileURL: String,
        nextRedirectPCURL: String,
        iosAppScheme: String,
        createdAt: String
    ) {
        self.tid = tid
        self.nextRedirectAppURL = nextRedirectAppURL
        self.nextRedirectMobileURL = nextRedirectMobileURL
        self.nextRedirectPCURL = nextRedirectPCURL
        self.iosAppScheme = iosAppScheme
        self.createdAt = createdAt
    }
}
