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
    @Dependency(\.postClient) var postClient
    
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var points: Int = 0
        var selectedCategory: Category = .hot
        var posts: [Post] = []
    }
    
    @Reducer(state: .equatable, action: .equatable)
    enum Path {
        case addPost(AddPostFeature)
        case postDetail(PostDetailFeature)
    }
    
    enum Action: Equatable, ViewAction {
        case path(StackActionOf<Path>)
        case logoutFail(String)
        case logoutSuccess
        case searchFail
        case searchSuccess
        case setPostsList([Post])
        case view(View)
        
        @CasePathable
        enum View: Equatable, BindableAction {
            case onAppear
            case binding(BindingAction<State>)
            case logoutButtonTapped
            case searchButtonTapped
            case createPostButtonTapped
            case postTapped
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
            case .setPostsList(let posts):
                state.posts = posts
                return .none
            case .view(.onAppear):
                return .run { send in
                    await send(self.getAllPosts())
                }
            case .view(.logoutButtonTapped):
                return .send(self.logout())
            case .view(.searchButtonTapped):
                return .run { send in
                    await send(self.searchGif(keyword: "cat"))
                }
            case .view(.createPostButtonTapped):
                state.path.append(.addPost(AddPostFeature.State()))
                return .none
            case .view(.postTapped):
                return .none
            case .view(.binding):
                return .none
            case .path(.element(_, .addPost(.view(.goBackButtonTapped)))):
                let _ = state.path.popLast()
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension HomeFeature {
    private func getAllPosts() async -> Action {
        let result = await postClient.getAllPosts()
        switch result {
        case .success(let posts):
            print("Posts: \(posts)")
            return .setPostsList(posts)
        case .failure(let failure):
            return .searchFail
        }
    }
    
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
