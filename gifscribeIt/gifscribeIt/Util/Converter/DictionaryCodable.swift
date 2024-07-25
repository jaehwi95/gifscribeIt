//
//  DictionaryCodable.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/25.
//

import Foundation

protocol DictionaryEncodable {
    func encode() throws -> Any
}

extension DictionaryEncodable where Self: Encodable {
    func encode() throws -> Any {
        let jsonData = try JSONEncoder().encode(self)
        return try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
    }
}

protocol DictionaryDecodable {
    static func decode(_ dictionary: Any) throws -> Self
}

extension DictionaryDecodable where Self: Decodable {
    static func decode(_ dictionary: Any) throws -> Self {
        let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        return try JSONDecoder().decode(Self.self, from: jsonData)
    }
}

typealias DictionaryCodable = DictionaryEncodable & DictionaryDecodable
