//
//  MainFeature.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/18.
//

import Foundation
import ComposableArchitecture
import FirebaseAuth

@Reducer
struct MainFeature {
    @Dependency(\.giphyClient) var giphyClient
    
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action: Equatable, ViewAction {
        case view(View)
        case logoutFail
        case logoutSuccess
        case searchFail
        case searchSuccess
        
        @CasePathable
        enum View: Equatable {
            case logoutButtonTapped
            case searchButtonTapped
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .logoutFail:
                return .none
            case .logoutSuccess:
                return .none
            case .searchFail:
                return .none
            case .searchSuccess:
                return .none
            case .view(.logoutButtonTapped):
                return .send(self.signOut())
            case .view(.searchButtonTapped):
                return .run { send in
                    await send(self.searchGif(keyword: "cat"))
                }
            }
        }
    }
}

extension MainFeature {
    private func signOut() -> Action {
        do {
            try Auth.auth().signOut()
            print("Signed out")
            return .logoutSuccess
        } catch {
            print("Firebase Auth Error: \(error)")
            return .logoutFail
        }
    }
    
    private func searchGif(keyword: String) async -> Action {
        let result = await giphyClient.searchGif(keyword)
        switch result {
        case .success(let result):
            print("Search Success \(result)")
            return .searchSuccess
        case .failure(let failure):
            print("Search Fail \(result)")
            return .searchFail
        }
    }
}
