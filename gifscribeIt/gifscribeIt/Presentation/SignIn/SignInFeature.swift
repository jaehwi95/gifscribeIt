//
//  SignInFeature.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/18.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct SignInFeature {
    @ObservableState
    public struct State: Equatable {
        
    }
    
    public enum Action {
        case navigateToMain
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .navigateToMain:
                return .none
            }
        }
    }
}
