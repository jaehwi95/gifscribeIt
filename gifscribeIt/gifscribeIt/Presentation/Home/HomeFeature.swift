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
        var posts: [PostModel] = [PostModel(), PostModel(), PostModel(), PostModel(), PostModel(), PostModel(), PostModel(), PostModel(), PostModel(), PostModel(), PostModel(), PostModel(), PostModel(), PostModel(), PostModel()]
    }
    
    @Reducer(state: .equatable, action: .equatable)
    enum Path {
        case addPost(AddPostFeature)
        case postDetail(PostDetailFeature)
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
            case addPostButtonTapped
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
            case .view(.logoutButtonTapped):
                return .send(self.logout())
            case .view(.searchButtonTapped):
                return .run { send in
                    await send(self.searchGif(keyword: "cat"))
                }
            case .view(.addPostButtonTapped):
                return .none
            case .view(.postTapped):
                return .none
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

struct PostModel: Equatable, Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let point: Int
    let gifPreviewUrl: String
    let gifContentUrl: String
    let userId: String
    let date: Date
    
    init(
        title: String,
        content: String,
        points: Int,
        gifPreviewUrl: String,
        gifContentUrl: String,
        userId: String,
        date: Date
    ) {
        self.title = title
        self.content = content
        self.point = points
        self.gifPreviewUrl = gifPreviewUrl
        self.gifContentUrl = gifContentUrl
        self.userId = userId
        self.date = date
    }
    
    init() {
        self.title = "Test Title"
        self.content = "Test Contents"
        self.point = 77
        self.gifPreviewUrl = "https://media2.giphy.com/media/MDJ9IbxxvDUQM/200_d.gif?cid=24c7c7bci45bku8uibsm9q602xbjah66zaek412se628r00a&ep=v1_gifs_search&rid=200_d.gif&ct=g"
        self.gifContentUrl = "https://media2.giphy.com/media/MDJ9IbxxvDUQM/giphy.gif?cid=24c7c7bci45bku8uibsm9q602xbjah66zaek412se628r00a&ep=v1_gifs_search&rid=giphy.gif&ct=g"
        self.userId = "jaehwi95@gmail.com"
        self.date = Date.now
    }
}
