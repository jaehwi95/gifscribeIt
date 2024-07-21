//
//  RootFeature.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/18.
//

import Foundation
import ComposableArchitecture

@Reducer(state: .equatable)
public enum RootFeature {
    case signIn(SignInFeature)
    case signUp(SignUpFeature)
    case main(MainFeature)
    
    public static var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .signIn(.navigateToMain):
                state = .main(MainFeature.State())
                return .none
            case .signIn(.navigateToSignUp):
                state = .signUp(SignUpFeature.State())
                return .none
            case .signIn:
                return .none
            case .signUp:
                return .none
            case .main(.goBack):
                state = .signIn(SignInFeature.State())
                return .none
            case .main:
                return .none
            }
        }
        .ifCaseLet(\.signIn, action: \.signIn) {
            SignInFeature()
        }
        .ifCaseLet(\.signUp, action: \.signUp) {
            SignUpFeature()
        }
        .ifCaseLet(\.main, action: \.main) {
            MainFeature()
        }
    }
}
