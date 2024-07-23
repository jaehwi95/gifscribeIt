//
//  GiphyClient.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/23.
//

import Foundation
import ComposableArchitecture
import Moya

struct GiphyClient {
    var searchGif: (_ keyword: String) async -> Result<SearchResult, GiphyError>
}

extension DependencyValues {
    var giphyClient: GiphyClient {
        get { self[GiphyClient.self] }
        set { self[GiphyClient.self] = newValue }
    }
}

extension GiphyClient: DependencyKey {
    static var liveValue = GiphyClient(
        searchGif: { keyword in
            let target: Giphy = Giphy.searchGifs(keyword: keyword)
            let response: Result<SearchGifResponse, GiphyError> = await GiphyProvider.request(target: target)
            return response.map { success in
                return success.toModel()
            }
        }
    )
}
