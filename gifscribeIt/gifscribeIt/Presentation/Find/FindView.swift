//
//  FindView.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/22.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@ViewAction(for: FindFeature.self)
struct FindView: View {
    @Perception.Bindable var store: StoreOf<FindFeature>
    
    var body: some View {
        WithPerceptionTracking {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.yellow, .clear]),
                    startPoint: .topTrailing,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                VStack(spacing: 40) {
                    Text("Reset Password")
                        .font(.custom("Noteworthy-Bold", size: 40))
                    Text("Enter a valid email to receive instructions on how to reset your password")
                        .font(.custom("Noteworthy-Bold", size: 16))
                    HStack {
                        Image(systemName: "envelope")
                        TextField("Email", text: $store.email)
                            .font(.custom("TrebuchetMS", size: 20))
                            .padding()
                    }
                    .underlined(color: .purple)
                    Button(
                        action: {
                            send(.resetPasswordButtonTapped)
                        }, label: {
                            Text("Send Email")
                                .font(.custom("TrebuchetMS", size: 20))
                                .padding(.vertical, 16)
                                .padding(.horizontal, 40)
                                .background(store.email.isEmpty ? .gray : .blue)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                    )
                    .disabled(store.email.isEmpty)
                }
                .padding(.horizontal, 20)
            }
            .loading(isLoading: store.isLoading)
            .alert($store.scope(state: \.alert, action: \.alert))
        }
    }
}
