//
//  gifscribeItApp.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/18.
//

import SwiftUI
import ComposableArchitecture

@main
struct gifscribeItApp: App {
    let store = Store(initialState: RootFeature.State.signIn(.init())) {
        RootFeature.body._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(store: store)
        }
    }
}
