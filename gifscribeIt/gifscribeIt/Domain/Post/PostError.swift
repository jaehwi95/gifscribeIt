//
//  PostError.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/25.
//

import Foundation

enum PostError: Error {
    case autoIdFailure
    case emptyPostId
    case invalidDatabasePath
    case parseError
    case pointIsNull
    case decodeError
    case otherError(String)
    case none
    
    /// TODO: handle error
//    var errorMessage: String {
//        switch self {
//            
//        }
//    }
}
