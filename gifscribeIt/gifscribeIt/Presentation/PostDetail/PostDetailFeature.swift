//
//  PostDetailFeature.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 7/25/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PostDetailFeature {
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action: Equatable, ViewAction {
        case view(View)
        
        @CasePathable
        enum View: Equatable {
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view:
                return .none
            }
        }
    }
}
