//
//  FindFeature.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/22.
//

import Foundation
import ComposableArchitecture

@Reducer
struct FindFeature {
    @Dependency(\.authClient) var authClient
    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        var email: String = ""
        var isLoading: Bool = false
    }
    
    enum Action: Equatable, ViewAction {
        case alert(PresentationAction<Alert>)
        case passwordResetFail(String)
        case passwordResetSuccess(String)
        case view(View)
        
        enum Alert: Equatable {
            case navigateToSignIn
        }
        
        enum View: Equatable, BindableAction {
            case binding(BindingAction<State>)
            case resetPasswordButtonTapped
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        Reduce { state, action in
            switch action {
            case .passwordResetFail(let errorMessage):
                state.isLoading = false
                state.alert = AlertState {
                    TextState("\(errorMessage)")
                }
                return .none
            case .passwordResetSuccess(let email):
                state.isLoading = false
                state.alert = AlertState(
                    title: TextState("Password Reset email sent to: \(email)"),
                    dismissButton: .default(TextState("Confirm"), action: .send(.navigateToSignIn))
                )
                return .none
            case .view(.resetPasswordButtonTapped):
                state.isLoading = true
                return .run {
                    [email = state.email] send in
                    await send(self.resetPassword(email: email))
                }
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

extension FindFeature {
    private func resetPassword(email: String) async -> Action {
        let result = await authClient.resetPassword(email)
        switch result {
        case .success(let email):
            return .passwordResetSuccess(email)
        case .failure(let failure):
            return .passwordResetFail(failure.errorMessage)
        }
    }
}
