//
//  MainFeature.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/18.
//

import Foundation
import ComposableArchitecture
import FirebaseAuth

@Reducer
struct MainFeature {
    enum Tab { case home, setting, pay }
    
    @ObservableState
    struct State: Equatable {
        var currentTab: Tab = .home
        var home = HomeFeature.State()
        var setting = SettingFeature.State()
        var pay = PayFeature.State()
    }
    
    enum Action: Equatable {
        case home(HomeFeature.Action)
        case setting(SettingFeature.Action)
        case pay(PayFeature.Action)
        case selectTab(Tab)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        Scope(state: \.setting, action: \.setting) {
            SettingFeature()
        }
        Scope(state: \.pay, action: \.pay) {
            PayFeature()
        }
        Reduce { state, action in
            switch action {
            case .home, .setting, .pay:
                return .none
            case .selectTab(let tab):
                state.currentTab = tab
                return .none
            }
        }
    }
}
