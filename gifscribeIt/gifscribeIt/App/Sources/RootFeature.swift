//
//  RootFeature.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/18.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RootFeature {
    @ObservableState
    enum State: Equatable {
        case signIn(SignInFeature.State)
        case main(MainFeature.State)
        
        init() {
            // check is signed in
            if true {
                self = .signIn(.init())
            } else {
                self = .main(.init())
            }
        }
    }
    
    enum Action: Equatable {
        case signIn(SignInFeature.Action)
        case main(MainFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .signIn:
                return .none
            case .main:
                return .none
            }
        }
        .ifCaseLet(\.signIn, action: \.signIn) {
            SignInFeature()
        }
        .ifCaseLet(\.main, action: \.main) {
            MainFeature()
        }
    }
}
