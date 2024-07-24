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
    enum Tab { case home, setting }
    
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var currentTab: Tab = .home
        var home = HomeFeature.State()
        var setting = SettingFeature.State()
    }
    
    @Reducer(state: .equatable, action: .equatable)
    enum Path {
        case addPost(AddPostFeature)
        case postDetail(PostDetailFeature)
    }
    
    enum Action: Equatable {
        case path(StackActionOf<Path>)
        case home(HomeFeature.Action)
        case setting(SettingFeature.Action)
        case selectTab(Tab)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        Scope(state: \.setting, action: \.setting) {
            SettingFeature()
        }
        Reduce { state, action in
            switch action {
            case .home(.view(.addPostButtonTapped)):
                state.path.append(.addPost(AddPostFeature.State()))
                return .none
            case .home(.view(.postTapped)):
                state.path.append(.postDetail(PostDetailFeature.State()))
                return .none
            case .home, .setting:
                return .none
            case .selectTab(let tab):
                state.currentTab = tab
                return .none
            case .path:
                return .none
            }
        }
    }
}
