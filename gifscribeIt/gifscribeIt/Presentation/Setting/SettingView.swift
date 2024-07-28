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
    @Bindable var store: StoreOf<SettingFeature>
    
    var body: some View {
        VStack(spacing: 40) {
            List {
                Section(header: Text("User Information")) {
                    HStack {
                        Text("User Email")
                        Spacer()
                        Text("\(store.user)")
                    }
                }
                Button("Log Out") {
                    send(.logoutButtonTapped)
                }
            }
        }
    }
}
