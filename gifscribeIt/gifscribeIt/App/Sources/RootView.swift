//
//  RootView.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/18.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    @Bindable var store: StoreOf<RootFeature>
    
    var body: some View {
        switch store.state {
        case .signIn:
            if let store = store.scope(state: \.signIn, action: \.signIn) {
                SignInView(store: store)
            }
        case .main:
            if let store = store.scope(state: \.main, action: \.main) {
                MainView(store: store)
            }
        }
    }
}
