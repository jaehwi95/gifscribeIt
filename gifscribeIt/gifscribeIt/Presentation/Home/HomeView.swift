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
    @Perception.Bindable var store: StoreOf<HomeFeature>
    
    var body: some View {
        WithPerceptionTracking {
            HomeViewBody
                .onAppear {
                    send(.onAppear)
                }
        }
    }
}

extension HomeView {
    private var HomeViewBody: some View {
        VStack {
            HStack {
                Text("\(store.points)")
                    .font(.custom("TrebuchetMS-Bold", size: 20))
                Picker("Categories", selection: $store.selectedCategory) {
                    ForEach(Category.allCases) { category in
                        Text(category.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 40)
                Button(
                    action: {
                        send(.createPostButtonTapped)
                    },
                    label: {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 20))
                    }
                )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            .overlay(Divider(), alignment: .bottom)
            ScrollView {
                VStack(spacing: 40) {
                    ForEach(store.posts, id: \.self.id) { post in
                        ZStack(alignment: .topTrailing) {
                            VStack(spacing: 20) {
                                Text("\(post.title)")
                                    .font(.custom("TrebuchetMS-Bold", size: 20))
                                HStack(spacing: 20) {
                                    GifImageView(url: post.gifPreviewUrl, attributionScale: 0.5)
                                        .frame(height: 200)
                                    VStack(spacing: 10) {
                                        Button(
                                            action: {
                                                send(.addPointToPost(post.id))
                                            },
                                            label: {
                                                Image(systemName: "arrowtriangle.up.fill")
                                                    .font(.system(size: 40))
                                            }
                                        )
                                        Text("\(post.point)")
                                        Button(
                                            action: {
                                                send(.minusPointToPost(post.id))
                                            },
                                            label: {
                                                Image(systemName: "arrowtriangle.down.fill")
                                                    .font(.system(size: 40))
                                            }
                                        )
                                        
                                    }
                                }
//                                HStack {
//                                    Spacer()
//                                    Text("\(post.user)")
//                                        .font(.system(size: 12))
//                                }
                                if post.id != store.posts.last?.id {
                                    Divider()
                                }
                            }
                            Button(
                                action: {
                                    send(.reportPostTapped(post.user, post.id))
                                },
                                label: {
                                    Image(systemName: "exclamationmark")
                                        .foregroundColor(Color(.systemRed))
                                }
                            )
                        }
                        
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .background(.mint.opacity(0.5))
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}
