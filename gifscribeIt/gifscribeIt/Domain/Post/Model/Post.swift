//
//  Post.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/25.
//

import Foundation

struct Post: Codable, Equatable, DictionaryCodable {
    var id: String? = nil
    let title: String
    let content: String
    let point: Int
    let gifPreviewUrl: String
    let gifContentUrl: String
    let user: String
    let date: Double
    
    init(
        title: String,
        content: String,
        point: Int,
        gifPreviewUrl: String,
        gifContentUrl: String,
        user: String,
        date: Double
    ) {
        self.title = title
        self.content = content
        self.point = point
        self.gifPreviewUrl = gifPreviewUrl
        self.gifContentUrl = gifContentUrl
        self.user = user
        self.date = date
    }
    
    init(
        id: String,
        title: String,
        content: String,
        point: Int,
        gifPreviewUrl: String,
        gifContentUrl: String,
        user: String,
        date: Double
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.point = point
        self.gifPreviewUrl = gifPreviewUrl
        self.gifContentUrl = gifContentUrl
        self.user = user
        self.date = date
    }
}

extension Post {
    func setId(id: String) -> Self {
        let newPost = Post(
            id: id,
            title: self.title,
            content: self.content,
            point: self.point,
            gifPreviewUrl: self.gifPreviewUrl,
            gifContentUrl: self.gifContentUrl,
            user: self.user,
            date: self.date
        )
        return newPost
    }
}
