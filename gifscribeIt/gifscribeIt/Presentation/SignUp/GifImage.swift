//
//  GifImage.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 7/24/24.
//

import Foundation
import WebKit
import SwiftUI

struct GifImage: UIViewRepresentable {
    private let url: String
    
    init(url: String) {
        self.url = url
    }
    
    func makeUIView(context: Context) -> some WKWebView {
        let webView = WKWebView()
        Task {
            if let url = URL(string: url), let data = await downloadData(url: url) {
                webView.load(
                    data,
                    mimeType: "image/gif",
                    characterEncodingName: "UTF-8",
                    baseURL: url
                )
                webView.scrollView.isScrollEnabled = false
            }
        }
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.reload()
    }
    
    private func downloadData(url: URL) async -> Data? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch let error {
            print(error)
            return nil
        }
    }
}
