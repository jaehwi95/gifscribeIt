//
//  MainView.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/18.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct MainView: View {
    let store: StoreOf<MainFeature>
    
    var body: some View {
        VStack {
            Text("Main View")
            Button("Go Back") {
                store.send(.goBack)
            }
        }
    }
}
