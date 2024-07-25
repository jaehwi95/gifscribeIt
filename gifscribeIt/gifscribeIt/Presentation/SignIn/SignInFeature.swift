//
//  SignInFeature.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/18.
//

import Foundation
import ComposableArchitecture
import FirebaseAuth

@Reducer
struct SignInFeature {
    @Dependency(\.authClient) var authClient
    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        var path = StackState<Path.State>()
        var email: String = ""
        var password: String = ""
    }
    
    @Reducer(state: .equatable, action: .equatable)
    enum Path {
//        case find(FindFeature)
        case signUp(SignUpFeature)
        case main(MainFeature)
    }
    
    enum Action: Equatable, ViewAction {
        case alert(PresentationAction<Alert>)
        case path(StackActionOf<Path>)
        case loginFail(String)
        case loginSuccess
        case view(View)
        
        enum Alert: Equatable {}
        
        enum View: Equatable, BindableAction {
            case binding(BindingAction<State>)
            case loginButtonTapped
//            case forgotIDPasswordTapped
            case createAccountTapped
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        Reduce { state, action in
            switch action {
            case .loginFail(let errorMessage):
                state.alert = AlertState {
                    TextState("\(errorMessage)")
                }
                return .none
            case .loginSuccess:
                print("jaebi: \(state.path)")
                state.path.append(.main(MainFeature.State()))
                print("jaebi: \(state.path)")
                return .none
            case .view(.loginButtonTapped):
                if state.email.isEmpty || state.password.isEmpty {
                    return .send(.loginFail("Please input Email / Password"))
                } else {
                    return .run { 
                        [email = state.email, password = state.password] send in
                        await send(self.signIn(email: email, password: password))
                    }
                }
//            case .view(.forgotIDPasswordTapped):
//                state.path.append(.find(FindFeature.State()))
//                return .none
            case .view(.createAccountTapped):
                state.path.append(.signUp(SignUpFeature.State()))
                return .none
            case .view(.binding):
                return .none
            case .alert:
                return .none
            case .path(.element(_, .signUp(.alert(.presented(.navigateToSignIn))))):
                state.path.removeLast()
                return .none
            case .path:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
        .forEach(\.path, action: \.path)
    }
}

extension SignInFeature {
    private func signIn(email: String, password: String) async -> Action {
        let result = await authClient.signIn(email, password)
        switch result {
        case .success(let email):
            return .loginSuccess
        case .failure(let failure):
            return .loginFail(failure.errorMessage)
        }
    }
}
