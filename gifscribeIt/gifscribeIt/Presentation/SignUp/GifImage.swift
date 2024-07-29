//
//  GifImage.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 7/24/24.
//

import Foundation
import SwiftUI
import Kingfisher

struct GifImageView: View {
    private let url: String
    private let attributionScale: Double
    
    init(url: String, attributionScale: Double) {
        self.url = url
        self.attributionScale = attributionScale
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            KFAnimatedImage.url(URL(string: url))
                .placeholder {
                    ProgressView()
                }
                .fade(duration: 0.5)
                .cancelOnDisappear(true)
            Image("giphyAttribution")
                .resizable()
                .frame(width: (100*attributionScale), height: (27*attributionScale))
        }
    }
}
