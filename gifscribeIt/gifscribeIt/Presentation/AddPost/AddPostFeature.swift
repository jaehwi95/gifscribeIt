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
    }
    
    enum Action: Equatable, ViewAction {
        case alert(PresentationAction<Alert>)
        case view(View)
        case addPostSuccess
        case addPostFailure
        case setSheet(Bool)
        
        enum Alert: Equatable {}
        
        @CasePathable
        enum View: BindableAction, Sendable, Equatable {
            case binding(BindingAction<State>)
            case goBackButtonTapped
            case addPostButtonTapped
            case searchGifButtonTapped
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
                state.gifPreviewUrl = "https://media3.giphy.com/media/yFQ0ywscgobJK/200_d.gif?cid=24c7c7bcb9zvxf7jyt0ctx3z0l9rfbkexagxn31t9lmcp125&ep=v1_gifs_search&rid=200_d.gif&ct=g"
                state.gifContentUrl = "https://media3.giphy.com/media/yFQ0ywscgobJK/giphy.gif?cid=24c7c7bcb9zvxf7jyt0ctx3z0l9rfbkexagxn31t9lmcp125&ep=v1_gifs_search&rid=giphy.gif&ct=g"
                return .send(.setSheet(true))
//                return .run { send in
//                    await send(self.getAllPosts())
//                }
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
}
