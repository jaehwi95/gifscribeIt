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
        case main(MainFeature)
    }
    
    enum Action: Equatable, ViewAction {
        case alert(PresentationAction<Alert>)
        case path(StackActionOf<Path>)
        case loginFail(LoginError)
        case loginSuccess
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
            case .loginFail(let loginError):
                state.loginError = loginError
                state.alert = AlertState {
                    TextState("\(state.loginError.rawValue)")
                }
                return .none
            case .loginSuccess:
                state.path.append(.main(MainFeature.State()))
                return .none
            case .view(.loginButtonTapped):
                if state.email.isEmpty || state.password.isEmpty {
                    return .send(.loginFail(.emptyFields))
                } else {
                    return .run { 
                        [email = state.email, password = state.password] send in
                        await send(self.signIn(email: email, password: password))
                    }
                }
            case .view(.forgotIDPasswordTapped):
                state.path.append(.find(FindFeature.State()))
                return .none
            case .view(.createAccountTapped):
                state.path.append(.signUp(SignUpFeature.State()))
                return .none
            case .alert:
                return .none
            case .path:
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
    case firebaseAuthFail = "Firebase Auth Failure"
}

extension SignInFeature {
    private func signIn(email: String, password: String) async -> Action {
        do {
            let result: AuthDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            let user = result.user
            print("Signed in as user \(user.uid), with email: \(user.email ?? "")")
            return .loginSuccess
        } catch {
            print("Firebase Auth Error: \(error)")
            return .loginFail(.firebaseAuthFail)
        }
    }
}
