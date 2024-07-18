//
//  RootView.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/18.
//

import SwiftUI
import ComposableArchitecture

public struct RootView: View {
    let store: StoreOf<RootFeature>
    
    public init(store: StoreOf<RootFeature>) {
        self.store = store
    }
    
    @State var isSignedIn: Bool = false
    
    public var body: some View {
        switch store.case {
        case let .signIn(store):
            NavigationStack {
                SignInView(store: store)
            }
        case let .main(store):
            NavigationStack {
                MainView(store: store)
            }
        }
    }
}
