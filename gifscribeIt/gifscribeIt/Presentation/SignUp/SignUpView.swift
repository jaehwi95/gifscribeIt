//
//  SignUpView.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 7/21/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@ViewAction(for: SignUpFeature.self)
struct SignUpView: View {
    @Bindable var store: StoreOf<SignUpFeature>
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sign Up View")
            TextField("Email", text: $store.email)
                .textFieldStyle(.roundedBorder)
                .padding()
            TextField("Password", text: $store.password)
                .textFieldStyle(.roundedBorder)
                .padding()
            TextField("Confirm Password", text: $store.password)
                .textFieldStyle(.roundedBorder)
                .padding()
            Button(
                action: {
                    send(.signUpButtonTapped)
                }, label: {
                    Text("Sign Up")
                }
            )
        }
    }
}
