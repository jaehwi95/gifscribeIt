//
//  MainView.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/18.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@ViewAction(for: MainFeature.self)
struct MainView: View {
    let store: StoreOf<MainFeature>
    
    var body: some View {
        VStack(spacing: 40) {
            Text("Main View")
            Button("Test get search") {
                send(.searchButtonTapped)
            }
            Button("Log Out") {
                send(.logoutButtonTapped)
            }
        }
    }
}
