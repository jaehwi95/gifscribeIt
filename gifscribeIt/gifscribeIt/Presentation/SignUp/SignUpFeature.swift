//
//  SignUpFeature.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 7/21/24.
//

import Foundation
import ComposableArchitecture
import FirebaseAuth

@Reducer
struct SignUpFeature {
    @Dependency(\.authClient) var authClient
    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        var email: String = ""
        var password: String = ""
        var confirmPassword: String = ""
    }
    
    enum Action: ViewAction, Equatable {
        case alert(PresentationAction<Alert>)
        case view(View)
        case signUpFail(String)
        case signUpSuccess(String)
        
        enum Alert: Equatable {
            case navigateToMain
        }
        
        @CasePathable
        enum View: BindableAction, Sendable, Equatable {
            case binding(BindingAction<State>)
            case signUpButtonTapped
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        Reduce { state, action in
            switch action {
            case .signUpFail(let errorMessage):
                state.alert = AlertState {
                    TextState("\(errorMessage)")
                }
                return .none
            case .signUpSuccess(let email):
                state.alert = AlertState(
                    title: TextState("Sign Up Success"),
                    message: TextState("Signing in as: \(email)"),
                    dismissButton: .default(TextState("Confirm"), action: .send(.navigateToMain))
                )
                return .none
            case .view(.signUpButtonTapped):
                let isAllTextFieldsFilled = [state.email, state.password, state.confirmPassword].allSatisfy { !$0.isEmpty }
                if isAllTextFieldsFilled {
                    return .run {
                        [email = state.email, password = state.password] send in
                        await send(self.signUp(email: email, password: password))
                    }
                } else {
                    return .send(.signUpFail("Please check your fields again"))
                }
            case .alert:
                return .none
            case .view(.binding):
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

extension SignUpFeature {
    private func signUp(email: String, password: String) async -> Action {
        let result = await authClient.signUp(email, password)
        switch result {
        case .success(let email):
            return .signUpSuccess(email)
        case .failure(let failure):
            return .signUpFail(failure.errorMessage)
        }
    }
}
