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
        case setPostsList([Post])
        case getAllPostsFail
        case updatePosts
        case view(View)
        
        @CasePathable
        enum View: Equatable, BindableAction {
            case onAppear
            case binding(BindingAction<State>)
            case createPostButtonTapped
            case addPointToPost(String?)
            case postTapped
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        Reduce { state, action in
            switch action {
            case .setPostsList(let posts):
                state.posts = sortPostsByPoints(posts: posts)
                return .none
            case .getAllPostsFail:
                return .none
            case .updatePosts:
                return .send(.view(.onAppear))
            case .view(.onAppear):
                return .run { send in
                    await send(self.getAllPosts())
                }
            case .view(.createPostButtonTapped):
                state.path.append(.addPost(AddPostFeature.State()))
                return .none
            case .view(.addPointToPost(let id)):
                return .run { send in
                    await send(self.addPoint(id: id))
                }
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
            return .setPostsList(posts)
        case .failure(let failure):
            return .getAllPostsFail
        }
    }
    
    private func addPoint(id: String?) async -> Action {
        guard let id = id else {
            return .getAllPostsFail
        }
        let result = await postClient.addPointFromPost(id)
        switch result {
        case .success:
            return .updatePosts
        case .failure(let failure):
            return .getAllPostsFail
        }
    }
}

extension HomeFeature {
    private func sortPostsByPoints(posts: [Post]) -> [Post] {
        let sortedList = posts.sorted(by: { $0.point > $1.point })
        return sortedList
    }
}

enum Category: String, CaseIterable, Identifiable {
    case hot, new, debated
    var id: Self { self }
}
