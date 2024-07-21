//
//  SignUpFeature.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 7/21/24.
//

import Foundation
import ComposableArchitecture
import FirebaseAuth

@Reducer
public struct SignUpFeature {
    @ObservableState
    public struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        var email: String = ""
        var password: String = ""
        var confirmPassword: String = ""
    }
    
    public enum Action: Sendable, ViewAction {
        case alert(PresentationAction<Alert>)
        case view(View)
        case signUp
        
        public enum Alert: Equatable, Sendable {}
        
        @CasePathable
        public enum View: BindableAction, Sendable {
            case binding(BindingAction<State>)
            case signUpButtonTapped
        }
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        Reduce { state, action in
            switch action {
            case .alert(_):
                return .none
            case .signUp:
                return .run { [email = state.email, password = state.password] send in
                    let resultCode = await emailAuthSignUp(email: email, password: password)
                    print("\(resultCode)")
                }
            case .view(.signUpButtonTapped):
                return .send(.signUp)
            case .view(.binding):
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

extension SignUpFeature {
    func emailAuthSignUp(email: String, password: String) async -> Int? {
        do {
            let result: AuthDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let user: User = result.user
            print("Signed in as user \(user.uid), with email: \(user.email ?? "")")
            return 200
        } catch {
            print("\(error)")
            return 0
        }
    }
}
