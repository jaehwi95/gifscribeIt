//
//  SignInFeature.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/18.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SignInFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        var path = StackState<Path.State>()
        var email: String = ""
        var password: String = ""
        var loginError: LoginError = .none
    }
    
    @Reducer(state: .equatable, action: .equatable)
    enum Path {
        case find(FindFeature)
        case signUp(SignUpFeature)
    }
    
    enum Action: Equatable, ViewAction {
        case alert(PresentationAction<Alert>)
        case path(StackActionOf<Path>)
        case onAppear
        case loginFail
        case view(View)
        
        enum Alert: Equatable {}
        
        enum View: Equatable, BindableAction {
            case binding(BindingAction<State>)
            case loginButtonTapped
            case forgotIDPasswordTapped
            case createAccountTapped
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let resultCode = await testAPI(url: "https://api.giphy.com/v1/gifs/random?api_key=&tag=&rating=g")
                    print("\(resultCode)")
                }
            case .loginFail:
                state.loginError = .emptyFields
                state.alert = AlertState { 
                    TextState("\(state.loginError.rawValue)")
                }
                return .none
            case .view(.loginButtonTapped):
                return .send(.loginFail)
            case .view(.forgotIDPasswordTapped):
                state.path.append(.find(FindFeature.State()))
                return .none
            case .view(.createAccountTapped):
                state.path.append(.signUp(SignUpFeature.State()))
                return .none
            case .path:
                return .none
            case .alert:
                return .none
            case .view(.binding):
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
        .forEach(\.path, action: \.path)
    }
}

enum LoginError: String {
    case none
    case emptyFields = "Please input Email / Password"
}

extension SignInFeature {
    func testAPI(url: String) async -> Int? {
        do {
            let result = try await GiphyAPIProvider().request(endpoint: url)
            return 200
        } catch {
            print("\(error)")
            return 0
        }
    }
}
