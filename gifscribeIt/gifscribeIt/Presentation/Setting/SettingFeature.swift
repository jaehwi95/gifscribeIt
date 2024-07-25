//
//  SettingFeature.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SettingFeature {
    @Dependency(\.authClient) var authClient
    
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action: Equatable, ViewAction {
        case view(View)
        case logoutFail(String)
        case logoutSuccess
        
        @CasePathable
        enum View: Equatable {
            case logoutButtonTapped
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .logoutFail:
                return .none
            case .logoutSuccess:
                return .none
            case .view(.logoutButtonTapped):
                return .send(self.logout())
            case .view:
                return .none
            }
        }
    }
}

extension SettingFeature {
    private func logout() -> Action {
        let result = authClient.logout()
        switch result {
        case .success:
            print("Logged out")
            return .logoutSuccess
        case .failure(let failure):
            return .logoutFail(failure.errorMessage)
        }
    }
}
