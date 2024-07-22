//
//  SignInView.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/18.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@ViewAction(for: SignInFeature.self)
struct SignInView: View {
    @Bindable var store: StoreOf<SignInFeature>
    
    init(store: StoreOf<SignInFeature>) {
        self.store = store
    }
    
    var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path),
            root: {
                SignInView
            },
            destination: { store in
                switch store.case {
                case .find(let store):
                    FindView(store: store)
                case .signUp(let store):
                    SignUpView(store: store)
                }
            }
        )
        .onAppear {
            store.send(.onAppear)
        }
    }
}

extension SignInView {
    private var SignInView: some View {
        VStack(spacing: 20) {
            Text("Sign In")
            TextField("Email", text: $store.email)
                .textFieldStyle(.roundedBorder)
                .padding()
            TextField("Password", text: $store.password)
                .textFieldStyle(.roundedBorder)
                .padding()
            VStack(spacing: 40) {
                Button(action: {
                    send(.loginButtonTapped)
                }, label: {
                    Text("Login")
                        .padding(.vertical, 16)
                        .padding(.horizontal, 40)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                })
                Button(
                    action: {
                        send(.forgotIDPasswordTapped)
                    }, label: {
                        Text("Forgot ID / Password?")
                    }
                )
                HStack(spacing: 0) {
                    Text("Don't have an account?")
                    Button(action: {
                        send(.createAccountTapped)
                    }, label: {
                        Text("Create Account")
                            .padding(.horizontal, 4)
                    })
                }
            }
        }
        .alert($store.scope(state: \.alert, action: \.alert))
        .padding(.horizontal, 20)
    }
}
