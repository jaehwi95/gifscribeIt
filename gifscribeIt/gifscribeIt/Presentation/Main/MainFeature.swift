//
//  MainFeature.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/18.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MainFeature {
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case goBack
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .goBack:
                return .none
            }
        }
    }
}
