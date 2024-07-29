//
//  RootView.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/18.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: RootFeature.self)
struct RootView: View {
    @Bindable var store: StoreOf<RootFeature>
    
    var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path),
            root: {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [.cyan, .mint]),
                        startPoint: .topTrailing,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    VStack(spacing: 20) {
                        Text("GifscribeIt")
                            .font(.custom("Noteworthy-Bold", size: 60))
                        Button(
                            action: {
                                send(.getStartedButtonTapped)
                            },
                            label: {
                                Text("Get Started")
                                    .fullWidth()
                            }
                        )
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                    .padding(.top, 40)
                    .padding(.horizontal, 20)
                }
            },
            destination: { store in
                switch store.case {
                case .signIn(let store):
                    SignInView(store: store)
                case .find(let store):
                    FindView(store: store)
                case .signUp(let store):
                    SignUpView(store: store)
                case .main(let store):
                    MainView(store: store)
                case .addPost(let store):
                    AddPostView(store: store)
                case .postDetail(let store):
                    PostDetailView(store: store)
                }
            }
        )
    }
}
