//
//  HomeFeature.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/24.
//

import Foundation
import ComposableArchitecture
import FirebaseFirestore

@Reducer
struct HomeFeature {
    @Dependency(\.authClient) var authClient
    @Dependency(\.giphyClient) var giphyClient
    
    @ObservableState
    struct State: Equatable {
        var points: Int = 0
        var selectedCategory: Category = .hot
    }
    
    enum Action: Equatable, ViewAction {
        case view(View)
        case logoutFail(String)
        case logoutSuccess
        case searchFail
        case searchSuccess
        
        @CasePathable
        enum View: Equatable, BindableAction {
            case binding(BindingAction<State>)
            case logoutButtonTapped
            case searchButtonTapped
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
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
                return .send(self.logout())
            case .view(.searchButtonTapped):
                return .run { send in
                    await send(self.searchGif(keyword: "cat"))
                }
            case .view(.binding):
                return .none
            }
        }
    }
}

extension HomeFeature {
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

enum Category: String, CaseIterable, Identifiable {
    case hot, new, debated
    var id: Self { self }
}
