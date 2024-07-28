//
//  View+.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 7/26/24.
//

import Foundation
import SwiftUI

extension View {
    func fullWidth() -> some View {
        frame(maxWidth: .infinity)
    }
    
    func fullHeight() -> some View {
        frame(maxHeight: .infinity)
    }
    
    func apply<V: View>(@ViewBuilder _ block: (Self) -> V) -> V { block(self) }
    
    func underlined(color: Color) -> some View {
        self
            .padding(.vertical, 10)
            .overlay(Rectangle().frame(height: 2).padding(.top, 35))
            .foregroundColor(color)
            .padding(10)
    }
    
    func loading(isLoading: Bool) -> Self {
        let loadingWindow = LoadingWindow.shared
        if isLoading {
            loadingWindow.show()
        } else {
            loadingWindow.hide()
        }
        return self
    }
}
