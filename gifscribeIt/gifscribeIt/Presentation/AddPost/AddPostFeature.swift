//
//  AddPostFeature.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 7/25/24.
//

import Foundation
import ComposableArchitecture
import FirebaseAuth
import FirebaseDatabase

@Reducer
struct AddPostFeature {
    @Dependency(\.postClient) var postClient
    @Dependency(\.giphyClient) var giphyClient
    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        var title: String = ""
        var content: String = ""
        var gifPreviewUrl: String = ""
        var gifContentUrl: String = ""
        var user: String {
            Auth.auth().currentUser?.email ?? ""
        }
        var date: Date = .now
        
        var isNextPossible: Bool {
            return [title, content, gifPreviewUrl, gifContentUrl, user].allSatisfy { !$0.isEmpty }
        }
        var isSheetPresented = false
        var searchText = ""
        
        var searchResultList: [GifItem] = []
    }
    
    enum Action: Equatable, ViewAction {
        case alert(PresentationAction<Alert>)
        case view(View)
        case addPostSuccess
        case addPostFailure
        case setSheet(Bool)
        case searchFail
        case searchSuccess
        case setSearchResultList([GifItem])
        
        enum Alert: Equatable {}
        
        @CasePathable
        enum View: BindableAction, Sendable, Equatable {
            case binding(BindingAction<State>)
            case goBackButtonTapped
            case addPostButtonTapped
            case searchGifButtonTapped
            case searchButtonTapped
            case gifItemTapped(String, String)
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        Reduce { state, action in
            switch action {
            case .addPostSuccess:
                return .none
            case .addPostFailure:
                return .none
            case .setSheet(let isPresented):
                state.isSheetPresented = isPresented
                return .none
            case .searchFail:
                return .none
            case .searchSuccess:
                return .none
            case .setSearchResultList(let gifItems):
                state.searchResultList = gifItems
                return .none
            case .view(.goBackButtonTapped):
                return .none
            case .view(.addPostButtonTapped):
                return .run { [title = state.title, content = state.content, gifPreviewUrl = state.gifPreviewUrl, gifContentUrl = state.gifContentUrl, user = state.user]
                    send in
                    await send(self.addPost(
                        title: title,
                        content: content,
                        gifPreviewUrl: gifPreviewUrl,
                        gifContentUrl: gifContentUrl,
                        user: user
                    ))
                }
            case .view(.searchGifButtonTapped):
                return .send(.setSheet(true))
            case .view(.searchButtonTapped):
                return .run { [keyword = state.searchText] send in
                    await send(self.searchGif(keyword: "\(keyword)"))
                }
            case .view(.gifItemTapped(let previewUrl, let contentUrl)):
                state.gifPreviewUrl = previewUrl
                state.gifContentUrl = contentUrl
                return .send(.setSheet(false))
            case .view(.binding):
                return .none
            case .alert:
                return .none
            }
        }
    }
}

extension AddPostFeature {
    private func addPost(title: String, content: String, gifPreviewUrl: String, gifContentUrl: String, user: String) async -> Action {
        let newPost = Post(
            title: title,
            content: content,
            point: 0,
            gifPreviewUrl: gifPreviewUrl,
            gifContentUrl: gifContentUrl,
            user: user,
            date: Date.now.timeIntervalSince1970
        )
        let result = postClient.addPost(newPost)
        switch result {
        case .success:
            return .addPostSuccess
        case .failure(let failure):
            return .addPostFailure
        }
    }
    
    private func searchGif(keyword: String) async -> Action {
        let result = await giphyClient.searchGif(keyword)
        switch result {
        case .success(let result):
            return .setSearchResultList(result.gifs)
        case .failure(let failure):
            return .searchFail
        }
    }
}
