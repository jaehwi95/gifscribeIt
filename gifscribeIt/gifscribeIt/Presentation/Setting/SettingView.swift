//
//  SettingView.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@ViewAction(for: SettingFeature.self)
struct SettingView: View {
    let store: StoreOf<SettingFeature>
    
    var body: some View {
        VStack(spacing: 40) {
            Text("Setting View")
            Button("Log Out") {
                send(.logoutButtonTapped)
            }
        }
//        .navigationBarBackButtonHidden(true)
    }
}
