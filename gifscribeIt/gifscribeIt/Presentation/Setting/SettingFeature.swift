//
//  SettingFeature.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/24.
//

import Foundation
import ComposableArchitecture
import FirebaseAuth

@Reducer
struct SettingFeature {
    @Dependency(\.authClient) var authClient
    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        var user: String {
            Auth.auth().currentUser?.email ?? ""
        }
        var isSheetPresented = false
        var isLoading: Bool = false
    }
    
    enum Action: Equatable, ViewAction {
        case alert(PresentationAction<Alert>)
        case view(View)
        case logoutFail(String)
        case logoutSuccess
        case deleteAccountFail(String)
        case deleteAccountSuccess
        case setSheet(Bool)
        
        enum Alert: Equatable {}
        
        @CasePathable
        enum View: Equatable, BindableAction {
            case binding(BindingAction<State>)
            case logoutButtonTapped
            case showDeleteAccountTapped
            case deleteAccountButtonTapped
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .logoutFail:
                return .none
            case .logoutSuccess:
                return .none
            case .deleteAccountFail(let errorMessage):
                state.isLoading = false
                state.alert = AlertState {
                    TextState("\(errorMessage)")
                }
                return .none
            case .deleteAccountSuccess:
                state.isLoading = false
                state.alert = AlertState {
                    TextState("Delete Account Success")
                }
                return .send(.setSheet(false))
            case .setSheet(let isPresented):
                state.isSheetPresented = isPresented
                return .none
            case .view(.logoutButtonTapped):
                return .send(self.logout())
            case .view(.showDeleteAccountTapped):
                return .send(.setSheet(true))
            case .view(.deleteAccountButtonTapped):
                state.isLoading = true
                return .run {
                    send in
                    await send(self.deleteAccount())
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

extension SettingFeature {
    private func logout() -> Action {
        let result = authClient.logout()
        switch result {
        case .success:
            return .logoutSuccess
        case .failure(let failure):
            return .logoutFail(failure.errorMessage)
        }
    }
    
    private func deleteAccount() async -> Action {
        let result = await authClient.deleteAccount()
        switch result {
        case .success:
            return .deleteAccountSuccess
        case .failure(let failure):
            return .deleteAccountFail(failure.errorMessage)
        }
    }
}
