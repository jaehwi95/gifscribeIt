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
    @Perception.Bindable var store: StoreOf<SignUpFeature>
    @State private var htmlAttributedString: AttributedString?
    
    var body: some View {
        WithPerceptionTracking {
            SignUpViewBody
                .alert($store.scope(state: \.alert, action: \.alert))
        }
    }
}

extension SignUpView {
    private var SignUpViewBody: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.yellow, .clear]),
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
                HStack {
                    Image(systemName: "key")
                    ZStack(alignment: .trailing) {
                        if store.isShowConfirmPassword {
                            TextField("Confirm Password", text: $store.confirmPassword)
                                .font(.custom("TrebuchetMS", size: 20))
                                .padding()
                        } else {
                            SecureField("Confirm Password", text: $store.confirmPassword)
                                .font(.custom("TrebuchetMS", size: 20))
                                .padding()
                        }
                        Button(
                            action: {
                                send(.toggleShowConfirmPasswordButtonTapped)
                            },
                            label: {
                                Image(systemName: store.isShowConfirmPassword ? "eye" : "eye.slash")
                            }
                        )
                    }
                }
                .underlined(color: .purple)
                HStack {
                    Toggle(isOn: $store.isAgreeTerms) {
                        Text("Terms of use")
                    }
                    .toggleStyle(ToggleCheckBoxStyle())
                    Spacer()
                    Button(
                        action: {
                            send(.showTermsSheetTapped)
                        },
                        label: {
                            Text("Show")
                        }
                    )
                }
                .padding(.horizontal, 20)
                HStack {
                    Toggle(isOn: $store.isAgreePrivacyPolicy) {
                        Text("Privacy Policy")
                    }
                    .toggleStyle(ToggleCheckBoxStyle())
                    Spacer()
                    Button(
                        action: {
                            send(.showPrivacyPolicyTapped)
                        },
                        label: {
                            Text("Show")
                        }
                    )
                }
                .padding(.horizontal, 20)
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
        .sheet(isPresented: $store.isTermsSheetPresented) {
            TermsofUseView
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $store.isPrivacyPolicySheetPresented) {
            PrivacyPolicyView
            .presentationDragIndicator(.visible)
        }
        .loading(isLoading: store.isLoading)
    }
}

extension SignUpView {
    private var TermsofUseView: some View {
        VStack(spacing: 20) {
            Text("Terms of use")
                .font(.system(size: 40))
            ScrollView {
                Text(htmlAttributedString ?? AttributedString(stringLiteral: ""))
            }
            .onAppear {
                DispatchQueue.main.async {
                    let attributedString = Agreements.termsOfUse.htmlString.attributedString()
                    htmlAttributedString = attributedString
                }
            }
            Button(
                action: {
                    send(.agreeTermsButtonTapped)
                }, label: {
                    Text("Agree")
                        .font(.system(size: 20))
                        .padding(.vertical, 16)
                        .padding(.horizontal, 40)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            )
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 40)
    }
    
    private var PrivacyPolicyView: some View {
        VStack(spacing: 20) {
            Text("Privacy Policy")
                .font(.system(size: 40))
            ScrollView {
                Text(htmlAttributedString ?? AttributedString(stringLiteral: ""))
            }
            .onAppear {
                DispatchQueue.main.async {
                    let attributedString = Agreements.privacyPolicy.htmlString.attributedString()
                    htmlAttributedString = attributedString
                }
            }
            Button(
                action: {
                    send(.agreePrivacyPolicyButtonTapped)
                }, label: {
                    Text("Agree")
                        .font(.system(size: 20))
                        .padding(.vertical, 16)
                        .padding(.horizontal, 40)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            )
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 40)
    }
}
