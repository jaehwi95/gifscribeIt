//
//  SearchResult.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/23.
//

import Foundation

struct SearchResult {
    let gifs: [GifItem]
    let count, offset: Int
    
    init(gifs: [GifItem], count: Int, offset: Int) {
        self.gifs = gifs
        self.count = count
        self.offset = offset
    }
}

struct GifItem {
    let originalURL: String
    let height200URL: String
    let height200DownsampledURL: String
    let height100URL: String
    let width200URL: String
    let width200DownsampledURL: String
    let width100URL: String
    
    init(
        originalURL: String,
        height200URL: String,
        height200DownsampledURL: String,
        height100URL: String,
        width200URL: String,
        width200DownsampledURL: String,
        width100URL: String
    ) {
        self.originalURL = originalURL
        self.height200URL = height200URL
        self.height200DownsampledURL = height200DownsampledURL
        self.height100URL = height100URL
        self.width200URL = width200URL
        self.width200DownsampledURL = width200DownsampledURL
        self.width100URL = width100URL
    }
}
