//
//  HomeFeature.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/24.
//

import Foundation
import ComposableArchitecture
import FirebaseFirestore
import FirebaseAuth

@Reducer
struct HomeFeature {
    @Dependency(\.postClient) var postClient
    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        var points: Int = 0
        var selectedCategory: Category = .hot
        var posts: [Post] = []
    }
    
    enum Action: Equatable, ViewAction {
        case alert(PresentationAction<Alert>)
        case setPostsList([Post])
        case getAllPostsFail
        case pointOperationFail
        case updatePosts
        case reportPostFail
        case reportPostSuccess
        case view(View)
        
        enum Alert: Equatable {
            case confirmReport(String?)
        }
        
        @CasePathable
        enum View: Equatable, BindableAction {
            case onAppear
            case binding(BindingAction<State>)
            case createPostButtonTapped
            case addPointToPost(String?)
            case minusPointToPost(String?)
            case reportPostTapped(String?)
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        Reduce { state, action in
            switch action {
            case .setPostsList(let posts):
                switch state.selectedCategory {
                case .hot:
                    state.posts = sortPostsByPointsDecreasing(posts: posts)
                case .new:
                    state.posts = sortPostsByDate(posts: posts)
                case .debated:
                    state.posts = sortPostsByPointsIncreasing(posts: posts)
                }
                return .none
            case .getAllPostsFail:
                return .none
            case .pointOperationFail:
                return .none
            case .updatePosts:
                return .send(.view(.onAppear))
            case .reportPostFail:
                return .none
            case .reportPostSuccess:
                return .none
            case .view(.onAppear):
                return .run { send in
                    await send(self.getAllPosts())
                }
            case .view(.createPostButtonTapped):
                print("add post")
                return .none
            case .view(.addPointToPost(let id)):
                return .run { send in
                    await send(self.addPoint(id: id))
                }
            case .view(.minusPointToPost(let id)):
                return .run { send in
                    await send(self.minusPoint(id: id))
                }
            case .view(.reportPostTapped(let id)):
                state.alert = AlertState(
                    title: TextState("Report Post?"),
                    message: TextState("If you report the post, we will take an appropriate action after a thorough review in 24 hours."),
                    primaryButton: .default(TextState("Confirm"), action: .send(.confirmReport(id))),
                    secondaryButton: .cancel(TextState("Cancel"))
                )
                return .none
            case .view(.binding(\.selectedCategory)):
                switch state.selectedCategory {
                case .hot:
                    state.posts = sortPostsByPointsDecreasing(posts: state.posts)
                case .new:
                    state.posts = sortPostsByDate(posts: state.posts)
                case .debated:
                    state.posts = sortPostsByPointsIncreasing(posts: state.posts)
                }
                return .none
            case .view(.binding):
                return .none
            case .alert(.presented(.confirmReport(let id))):
                state.alert = nil
                return .run { send in
                    await send(self.reportPost(id: id, reportCategory: "Inappropriate"))
                }
            case .alert:
                state.alert = nil
                return .none
            }
        }
    }
}

extension HomeFeature {
    private func getAllPosts() async -> Action {
        let result = await postClient.getAllPosts()
        switch result {
        case .success(let posts):
            return .setPostsList(posts)
        case .failure(_):
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
        case .failure(_):
            return .pointOperationFail
        }
    }
    
    private func minusPoint(id: String?) async -> Action {
        guard let id = id else {
            return .getAllPostsFail
        }
        let result = await postClient.subtractPointFromPost(id)
        switch result {
        case .success:
            return .updatePosts
        case .failure(_):
            return .pointOperationFail
        }
    }
    
    private func reportPost(id: String?, reportCategory: String) async -> Action {
        guard let id = id else {
            return .getAllPostsFail
        }
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            return .getAllPostsFail
        }
        let result = await postClient.reportPost(id, reportCategory, currentUserEmail)
        switch result {
        case .success:
            return .reportPostSuccess
        case .failure(_):
            return .reportPostFail
        }
    }
}

extension HomeFeature {
    private func sortPostsByPointsDecreasing(posts: [Post]) -> [Post] {
        let sortedList = posts.sorted(by: { $0.point > $1.point })
        return sortedList
    }
    
    private func sortPostsByDate(posts: [Post]) -> [Post] {
        let sortedList = posts.sorted(by: { $0.date > $1.date })
        return sortedList
    }
    
    private func sortPostsByPointsIncreasing(posts: [Post]) -> [Post] {
        let sortedList = posts.sorted(by: { $0.point < $1.point })
        return sortedList
    }
}

enum Category: String, CaseIterable, Identifiable {
    case hot, new, debated
    var id: Self { self }
}
