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
    @Perception.Bindable var store: StoreOf<MainFeature>
    
    var body: some View {
        WithPerceptionTracking {
            TabView(selection: $store.currentTab.sending(\.selectTab)) {
                HomeView(
                    store: store.scope(state: \.home, action: \.home)
                )
                .tag(MainFeature.Tab.home)
                .tabItem {
                    Image(systemName: "house")
                }
                SettingView(
                    store: store.scope(state: \.setting, action: \.setting)
                )
                .tag(MainFeature.Tab.setting)
                .tabItem {
                    Image(systemName: "gearshape")
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
