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
        var path: StackState = StackState<Path.State>()
        var pathStack: [String] = []
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
        case printPath
        
        @CasePathable
        enum View: Equatable {
            case getStartedButtonTapped
        }
    }
    
    private func push(_ state: inout State, pathState: RootFeature.Path.State) {
        state.path.append(pathState)
//        state.pathStack.append(pathState.v alue)
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
                return .send(.printPath)
            case .path(.element(_, .signIn(.view(.createAccountTapped)))):
                state.path.append(.signUp(SignUpFeature.State()))
                return .send(.printPath)
            case .path(.element(_, .signIn(.loginSuccess))):
                state.path.append(.main(MainFeature.State()))
                return .send(.printPath)
            case .path(.element(_, .signIn(.view(.forgotPasswordTapped)))):
                state.path.append(.find(FindFeature.State()))
                return .send(.printPath)
            case .path(.element(_, .signUp(.alert(.presented(.navigateToSignIn))))):
                state.path.removeLast()
                return .send(.printPath)
            case .path(.element(_, .main(.home(.view(.createPostButtonTapped))))):
                state.path.append(.addPost(AddPostFeature.State()))
                return .send(.printPath)
            case .path(.element(_, .main(.setting(.logoutSuccess)))):
                state.path.removeAll()
                state.path.append(.signIn(SignInFeature.State()))
                return .send(.printPath)
            case .path(.element(_, .main(.setting(.deleteAccountSuccess)))):
                state.path.removeAll()
                state.path.append(.signIn(SignInFeature.State()))
                return .send(.printPath)
            case .path(.element(_, .addPost(.view(.goBackButtonTapped)))):
                state.path.removeLast()
                return .send(.printPath)
            case .path(.element(_, .addPost(.addPostSuccess))):
                state.path.removeLast()
                return .send(.printPath)
            case .path:
                return .send(.printPath)
            case .printPath:
                print("NavigationStack: \(state.path)")
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
