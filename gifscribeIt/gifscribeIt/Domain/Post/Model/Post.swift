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
    let report: Report?
    
    init(
        title: String,
        content: String,
        point: Int,
        gifPreviewUrl: String,
        gifContentUrl: String,
        user: String,
        date: Double,
        report: Report? = nil
    ) {
        self.title = title
        self.content = content
        self.point = point
        self.gifPreviewUrl = gifPreviewUrl
        self.gifContentUrl = gifContentUrl
        self.user = user
        self.date = date
        self.report = report
    }
    
    init(
        id: String,
        title: String,
        content: String,
        point: Int,
        gifPreviewUrl: String,
        gifContentUrl: String,
        user: String,
        date: Double,
        report: Report?
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.point = point
        self.gifPreviewUrl = gifPreviewUrl
        self.gifContentUrl = gifContentUrl
        self.user = user
        self.date = date
        self.report = report
    }
}

struct Report: Codable, Equatable, DictionaryCodable {
    let reportCategory: String
    let reportUser: String
    
    init(reportCategory: String, reportUser: String) {
        self.reportCategory = reportCategory
        self.reportUser = reportUser
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
            date: self.date,
            report: self.report
        )
        return newPost
    }
}
