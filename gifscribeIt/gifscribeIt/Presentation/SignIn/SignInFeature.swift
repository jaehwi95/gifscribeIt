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
        @Presents var alert: AlertState<Action.Alert>?
        var email: String = ""
        var password: String = ""
        var loginError: LoginError = .none
    }
    
    public enum Action: Sendable, ViewAction {
        case alert(PresentationAction<Alert>)
        case loginFail
        case view(View)
        case navigateToMain
        case navigateToSignUp
        
        public enum Alert: Equatable, Sendable {}
        
        @CasePathable
        public enum View: BindableAction, Sendable {
            case binding(BindingAction<State>)
            case loginButtonTapped
            case forgotIDPasswordTapped
            case createAccountTapped
        }
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        Reduce { state, action in
            switch action {
            case .alert(_):
                return .none
            case .loginFail:
                state.loginError = .emptyFields
                state.alert = AlertState { 
                    TextState("Error")
                }
                return .none
            case .view(.binding(\.password)):
                return .none
            case .view(.binding(\.email)):
                // validation check
                return .none
            case .view(.loginButtonTapped):
                return .run { send in
                    await send(.loginFail)
                }
            case .view(.forgotIDPasswordTapped):
                return .none
            case .view(.createAccountTapped):
                return .run { send in
                    await send(.navigateToSignUp)
                }
            case .view(.binding):
                return .none
            case .navigateToMain:
                return .none
            case .navigateToSignUp:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

enum LoginError {
    case none
    case emptyFields
}
