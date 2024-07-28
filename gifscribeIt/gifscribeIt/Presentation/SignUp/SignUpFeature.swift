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
        var isSignUpPossible: Bool {
            !password.isEmpty && (password == confirmPassword)
        }
        var isLoading: Bool = false
        var isShowPassword: Bool = false
        var isShowConfirmPassword: Bool = false
    }
    
    enum Action: ViewAction, Equatable {
        case alert(PresentationAction<Alert>)
        case view(View)
        case signUpFail(String)
        case signUpSuccess(String)
        case logoutFail(String)
        
        enum Alert: Equatable {
            case navigateToSignIn
        }
        
        @CasePathable
        enum View: BindableAction, Sendable, Equatable {
            case binding(BindingAction<State>)
            case signUpButtonTapped
            case toggleShowPasswordButtonTapped
            case toggleShowConfirmPasswordButtonTapped
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        Reduce { state, action in
            switch action {
            case .signUpFail(let errorMessage):
                state.isLoading = false
                state.alert = AlertState {
                    TextState("\(errorMessage)")
                }
                return .none
            case .signUpSuccess(let email):
                state.isLoading = false
                state.alert = AlertState(
                    title: TextState("Sign Up Success"),
                    message: TextState("Account created: \(email). Please Login"),
                    dismissButton: .default(TextState("Confirm"), action: .send(.navigateToSignIn))
                )
                return .none
            case .logoutFail(let errorMessage):
                state.isLoading = false
                state.alert = AlertState {
                    TextState("\(errorMessage)")
                }
                return .none
            case .view(.signUpButtonTapped):
                let isAllTextFieldsFilled = [state.email, state.password, state.confirmPassword].allSatisfy { !$0.isEmpty }
                if isAllTextFieldsFilled {
                    state.isLoading = true
                    return .run {
                        [email = state.email, password = state.password] send in
                        await send(self.signUp(email: email, password: password))
                    }
                } else {
                    return .send(.signUpFail("Please check your fields again"))
                }
            case .view(.toggleShowPasswordButtonTapped):
                state.isShowPassword.toggle()
                return .none
            case .view(.toggleShowConfirmPasswordButtonTapped):
                state.isShowConfirmPassword.toggle()
                return .none
            case .view(.binding):
                return .none
            case .alert:
                state.alert = nil
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
            return logout(email: email)
        case .failure(let failure):
            return .signUpFail(failure.errorMessage)
        }
    }
    
    private func logout(email: String) -> Action {
        let result = authClient.logout()
        switch result {
        case .success:
            return .signUpSuccess(email)
        case .failure(let failure):
            return .logoutFail(failure.errorMessage)
        }
    }
}
