//
//  HomeView.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@ViewAction(for: HomeFeature.self)
struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>
    
    var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path),
            root: {
                HomeViewBody
            },
            destination: { store in
                switch store.case {
                case .addPost(let store):
                    AddPostView(store: store)
                case .postDetail(let store):
                    PostDetailView(store: store)
                }
            }
        )
        .onAppear {
            send(.onAppear)
        }
    }
}

extension HomeView {
    private var HomeViewBody: some View {
        ScrollView {
            VStack(spacing: 40) {
                ForEach(store.posts, id: \.self.id) { post in
                    VStack(spacing: 20) {
                        Text("\(post.title)")
                        HStack {
                            GifImage(url: post.gifPreviewUrl)
                                .frame(height: 200)
                            VStack {
                                Image(systemName: "arrowtriangle.up")
                                Text("\(post.point)")
                                Image(systemName: "arrowtriangle.down")
                            }
                        }
                        if post.id != store.posts.last?.id {
                            Divider()
                        }
                    }
                }
                Text("Home View")
                Button("Test get search") {
                    send(.searchButtonTapped)
                }
                Button("Log Out") {
                    send(.logoutButtonTapped)
                }
            }
            .padding(.horizontal, 20)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("\(store.points)")
            }
            ToolbarItemGroup(placement: .principal) {
                Picker("Categories", selection: $store.selectedCategory) {
                    ForEach(Category.allCases) { category in
                        Text(category.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 40)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    action: {
                        send(.createPostButtonTapped)
                    },
                    label: {
                        Image(systemName: "square.and.pencil")
                    }
                )
            }
        }
    }
}
