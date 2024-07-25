//
//  SignUpView.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 7/21/24.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: SignUpFeature.self)
struct SignUpView: View {
    @Bindable var store: StoreOf<SignUpFeature>
    
    var body: some View {
        SignUpViewBody
            .alert($store.scope(state: \.alert, action: \.alert))
    }
}

extension SignUpView {
    private var SignUpViewBody: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.yellow, .mint]),
                startPoint: .topTrailing,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack(spacing: 40) {
                Text("Create Account")
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
                    TextField("Password", text: $store.password)
                        .font(.custom("TrebuchetMS", size: 20))
                        .padding()
                }
                .underlined(color: .purple)
                HStack {
                    Image(systemName: "key")
                    TextField("Confirm Password", text: $store.confirmPassword)
                        .font(.custom("TrebuchetMS", size: 20))
                        .padding()
                }
                .underlined(color: .purple)
                Button(
                    action: {
                        send(.signUpButtonTapped)
                    }, label: {
                        Text("Create Account")
                            .font(.custom("TrebuchetMS", size: 20))
                            .padding(.vertical, 16)
                            .padding(.horizontal, 40)
                            .background(store.isSignUpPossible ? .blue : .gray)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                )
                .disabled(!store.isSignUpPossible)
            }
            .padding(.horizontal, 20)
        }
    }
}
