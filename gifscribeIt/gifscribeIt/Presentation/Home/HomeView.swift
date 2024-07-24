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
        NavigationStack {
            ScrollView {
                VStack(spacing: 40) {
                    ForEach(store.posts) { post in
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
                            send(.addPostButtonTapped)
                        },
                        label: {
                            Image(systemName: "square.and.pencil")
                        }
                    )
                }
            }
        }
    }
}

extension HomeView {
    
}
