//
//  RootFeature.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/18.
//

import Foundation
import ComposableArchitecture
import FirebaseAuth

@Reducer
struct RootFeature {
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
    }
    
    @Reducer(state: .equatable, action: .equatable)
    enum Path {
        case signIn(SignInFeature)
        case find(FindFeature)
        case signUp(SignUpFeature)
        case main(MainFeature)
        case addPost(AddPostFeature)
        case postDetail(PostDetailFeature)
    }
    
    enum Action: Equatable, ViewAction {
        case path(StackActionOf<Path>)
        case view(View)
        
        @CasePathable
        enum View: Equatable {
            case getStartedButtonTapped
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.getStartedButtonTapped):
                if Auth.auth().currentUser?.uid != nil {
                    state.path.append(.main(MainFeature.State()))
                } else {
                    state.path.append(.signIn(SignInFeature.State()))
                }
                return .none
            case .path(.element(_, .signIn(.view(.createAccountTapped)))):
                state.path.append(.signUp(SignUpFeature.State()))
                return .none
            case .path(.element(_, .signIn(.loginSuccess))):
                state.path.append(.main(MainFeature.State()))
                return .none
            case .path(.element(_, .signIn(.view(.forgotPasswordTapped)))):
                state.path.append(.find(FindFeature.State()))
                return .none
            case .path(.element(_, .signUp(.alert(.presented(.navigateToSignIn))))):
                state.path.removeLast()
                return .none
            case .path(.element(_, .main(.home(.view(.createPostButtonTapped))))):
                state.path.append(.addPost(AddPostFeature.State()))
                return .none
            case .path(.element(_, .addPost(.view(.goBackButtonTapped)))):
                state.path.removeLast()
                return .none
            case .path(.element(_, .addPost(.addPostSuccess))):
                state.path.removeLast()
                return .none
            case .path(.element(_, .main(.setting(.logoutSuccess)))):
                state.path.removeAll()
                state.path.append(.signIn(SignInFeature.State()))
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
