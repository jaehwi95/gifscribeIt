//
//  SignInFeature.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/18.
//

import Foundation
import ComposableArchitecture
import FirebaseAuth

@Reducer
struct SignInFeature {
    @Dependency(\.authClient) var authClient
    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        var email: String = ""
        var password: String = ""
    }
    
    enum Action: Equatable, ViewAction {
        case alert(PresentationAction<Alert>)
        case loginFail(String)
        case loginSuccess
        case view(View)
        
        enum Alert: Equatable {}
        
        enum View: Equatable, BindableAction {
            case binding(BindingAction<State>)
            case loginButtonTapped
            case forgotPasswordTapped
            case createAccountTapped
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        Reduce { state, action in
            switch action {
            case .loginFail(let errorMessage):
                state.alert = AlertState {
                    TextState("\(errorMessage)")
                }
                return .none
            case .loginSuccess:
                return .none
            case .view(.loginButtonTapped):
                if state.email.isEmpty || state.password.isEmpty {
                    return .send(.loginFail("Please input Email / Password"))
                } else {
                    return .run { 
                        [email = state.email, password = state.password] send in
                        await send(self.signIn(email: email, password: password))
                    }
                }
            case .view(.forgotPasswordTapped):
                return .none
            case .view(.createAccountTapped):
                return .none
            case .view(.binding):
                return .none
            case .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

extension SignInFeature {
    private func signIn(email: String, password: String) async -> Action {
        let result = await authClient.signIn(email, password)
        switch result {
        case .success:
            return .loginSuccess
        case .failure(let failure):
            return .loginFail(failure.errorMessage)
        }
    }
}
