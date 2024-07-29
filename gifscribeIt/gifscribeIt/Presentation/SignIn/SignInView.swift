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
    
    var body: some View {
        SignInViewBody
            .alert($store.scope(state: \.alert, action: \.alert))
    }
}

extension SignInView {
    private var SignInViewBody: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.cyan, .mint]),
                startPoint: .topTrailing,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("GifscribeIt")
                    .font(.custom("Noteworthy-Bold", size: 40))
                HStack {
                    Image(systemName: "envelope")
                    TextField("Email", text: $store.email)
                        .font(.custom("TrebuchetMS", size: 20))
                        .padding()
                }
                .underlined(color: .purple)
                HStack {
                    Image(systemName: "key")
                    ZStack(alignment: .trailing) {
                        if store.isShowPassword {
                            TextField("Password", text: $store.password)
                                .font(.custom("TrebuchetMS", size: 20))
                                .padding()
                        } else {
                            SecureField("Password", text: $store.password)
                                .font(.custom("TrebuchetMS", size: 20))
                                .padding()
                        }
                        Button(
                            action: {
                                send(.toggleShowPasswordButtonTapped)
                            },
                            label: {
                                Image(systemName: store.isShowPassword ? "eye" : "eye.slash")
                            }
                        )
                    }
                }
                .underlined(color: .purple)
                VStack(spacing: 40) {
                    Button(
                        action: {
                            send(.loginButtonTapped)
                        }, label: {
                            Text("Login")
                                .font(.custom("TrebuchetMS", size: 20))
                                .padding(.vertical, 16)
                                .padding(.horizontal, 40)
                                .background(.blue)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                    )
                    .padding(.bottom, 80)
                    Button(
                        action: {
                            send(.forgotPasswordTapped)
                        }, label: {
                            Text("Forgot Password?")
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
            .padding(.horizontal, 20)
        }
        .loading(isLoading: store.isLoading)
        .navigationBarBackButtonHidden(true)
    }
}
