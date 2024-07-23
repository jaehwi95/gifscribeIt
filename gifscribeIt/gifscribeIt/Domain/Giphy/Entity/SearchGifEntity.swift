//
//  SearchGifEntity.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/23.
//

import Foundation

struct SearchGifResponse: Codable {
    let data: [GIF?]?
    let meta: Meta?
    let pagination: Pagination?
}

struct GIF: Codable {
    let type: String?
    let id: String?
    let slug: String?
    let url: String?
    let bitlyURL: String?
    let embedURL: String?
    let username: String?
    let source: String?
    let rating: String?
    let contentURL: String?
    let user: User?
    let sourceTLD: String?
    let sourcePostURL: String?
    let updateDatetime: String?
    let createDatetime: String?
    let importDatetime: String?
    let trendingDatetime: String?
    let images: Images?
    let title: String?
    let altText: String?
    
    enum CodingKeys: String, CodingKey {
        case type, id, slug, url
        case bitlyURL = "bitly_url"
        case embedURL = "embed_url"
        case username, source, rating
        case contentURL = "content_url"
        case user = "user"
        case sourceTLD = "source_tld"
        case sourcePostURL = "source_post_url"
        case updateDatetime = "update_datetime"
        case createDatetime = "create_datetime"
        case importDatetime = "import_datetime"
        case trendingDatetime = "trending_datetime"
        case images = "images"
        case title = "title"
        case altText = "alt_text"
    }
}

struct User: Codable {
    let avatarURL: String?
    let bannerURL: String?
    let profileURL: String?
    let username: String?
    let displayName: String?
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case bannerURL = "banner_url"
        case profileURL = "profile_url"
        case username = "username"
        case displayName = "display_name"
    }
}

/// contains rendition objects - URLs and sizes for many different rendictions offered
struct Images: Codable {
    let fixedHeight: RenditionObject?
    let fixedHeightStill: RenditionObject?
    let fixedHeightDownsampled: RenditionObject?
    let fixedWidth: RenditionObject?
    let fixedWidthStill: RenditionObject?
    let fixedWidthDownsampled: RenditionObject?
    let fixedHeightSmall: RenditionObject?
    let fixedHeightStillSmall: RenditionObject?
    let fixedWidthSmall: RenditionObject?
    let fixedWidthStillSmall: RenditionObject?
    let downsized: RenditionObject?
    let downsizedStill: RenditionObject?
    let downsizedLarge: RenditionObject?
    let downsizedMedium: RenditionObject?
    let downsizedSmall: RenditionObject?
    let original: RenditionObject?
    let originalStill: RenditionObject?
    let looping: RenditionObject?
    let previewMP4: RenditionObject?
    let previewGif: RenditionObject?
    
    enum CodingKeys: String, CodingKey {
        case fixedHeight = "fixed_height"
        case fixedHeightStill = "fixed_height_still"
        case fixedHeightDownsampled = "fixed_height_downsampled"
        case fixedWidth = "fixed_width"
        case fixedWidthStill = "fixed_width_still"
        case fixedWidthDownsampled = "fixed_width_downsampled"
        case fixedHeightSmall = "fixed_height_small"
        case fixedHeightStillSmall = "fixed_height_small_still"
        case fixedWidthSmall = "fixed_width_small"
        case fixedWidthStillSmall = "fixed_width_small_still"
        case downsized = "downsized"
        case downsizedStill = "downsized_still"
        case downsizedLarge = "downsized_large"
        case downsizedMedium = "downsized_medium"
        case downsizedSmall = "downsized_small"
        case original = "original"
        case originalStill = "original_still"
        case looping = "looping"
        case previewMP4 = "preview"
        case previewGif = "preview_gif"
    }
}

struct RenditionObject: Codable {
    let url: String?
    let width, height, size, frames: String?
    let mp4: String?
    let mp4Size: String?
    let webp: String?
    let webpSize: String?
    
    enum CodingKeys: String, CodingKey {
        case url, width, height, size, frames
        case mp4
        case mp4Size = "mp4_size"
        case webp
        case webpSize = "webp_size"
    }
}

/// contains basic information regarding the response and its status
struct Meta: Codable {
    let status: Int?
    let msg, responseID: String?
    
    enum CodingKeys: String, CodingKey {
        case status, msg
        case responseID = "response_id"
    }
}

/// contains information relating to the number of total results available, number of results fetched, and their relative positions
struct Pagination: Codable {
    let totalCount, count, offset: Int?
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count, offset
    }
}

extension SearchGifResponse {
    func toModel() -> SearchResult {
        return SearchResult.init(
            gifs: self.data?.map{ gif in
                GifItem(
                    originalURL: gif?.images?.original?.url ?? "",
                    height200URL: gif?.images?.fixedHeight?.url ?? "",
                    height200DownsampledURL: gif?.images?.fixedHeightDownsampled?.url ?? "",
                    height100URL: gif?.images?.fixedHeightSmall?.url ?? "",
                    width200URL: gif?.images?.fixedWidth?.url ?? "",
                    width200DownsampledURL: gif?.images?.fixedWidthDownsampled?.url ?? "",
                    width100URL: gif?.images?.fixedWidthSmall?.url ?? ""
                )
            } ?? [],
            count: self.pagination?.count ?? 0,
            offset: self.pagination?.offset ?? 0
        )
    }
}
