//
//  AddPostFeature.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 7/25/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AddPostFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        var title: String = ""
        var content: String = ""
        var gifUrl: String = ""
        var userId: String = ""
        var date: Date = .now
    }
    
    enum Action: Equatable, ViewAction {
        case alert(PresentationAction<Alert>)
        case view(View)
        
        enum Alert: Equatable {}
        
        @CasePathable
        enum View: BindableAction, Sendable, Equatable {
            case binding(BindingAction<State>)
            case addPostButtonTapped
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        Reduce { state, action in
            switch action {
            case .view:
                return .none
            case .alert:
                return .none
            }
        }
    }
}
