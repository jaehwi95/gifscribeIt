//
//  AddPostView.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 7/25/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@ViewAction(for: AddPostFeature.self)
struct AddPostView: View {
    @Bindable var store: StoreOf<AddPostFeature>
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        Form {
            Section("Title*") {
                TextField("Title", text: $store.title, axis: .vertical)
                    .lineLimit(2)
            }
            Section("Content") {
                TextField("Content", text: $store.content, axis: .vertical)
                    .lineLimit(5...10)
            }
            Section("GIF*") {
                Button(
                    action: {
                        send(.searchGifButtonTapped)
                    }, label: {
                        Text("Select GIF")
                    }
                )
                if !store.gifContentUrl.isEmpty {
                    GifImage(url: store.gifContentUrl)
                        .frame(height: 200)
                }
            }
            Section("User*") {
                Text("\(store.user)")
            }
            Section("Date") {
                Text("\(store.date.formatted(date: .complete, time: .complete))")
            }
            Section(
                content: {
                    EmptyView()
                },
                footer: {
                    HStack(spacing: 40) {
                        Button(
                            action: {
                                send(.goBackButtonTapped)
                            },
                            label: {
                                Text("Go Back")
                                    .font(.system(size: 16))
                                    .foregroundStyle(Color.white)
                            }
                        )
                        .padding()
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        Button(
                            action: {
                                send(.addPostButtonTapped)
                            },
                            label: {
                                Text("Add Post")
                                    .font(.system(size: 16))
                                    .foregroundStyle(Color.white)
                            }
                        )
                        .padding()
                        .background(store.isNextPossible ? .blue : .gray)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .disabled(!store.isNextPossible)
                    }
                    .fullWidth()
                }
            )
        }
        .navigationTitle("Add Post")
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $store.isSheetPresented.sending(\.setSheet)) {
            VStack {
                SearchGifView
            }
            .presentationDragIndicator(.visible)
        }
    }
}

extension AddPostView {
    private var SearchGifView: some View {
        VStack {
            HStack {
                HStack(spacing: 20) {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $store.searchText)
                        .foregroundColor(.primary)
                    if !store.searchText.isEmpty {
                        Button(
                            action: {
                                send(.clearSearchTextButtonTapped)
                            },
                            label: {
                                Image(systemName: "xmark.circle.fill")
                            }
                        )
                    } else {
                        EmptyView()
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(4)
                Button(
                    action: {
                        send(.searchButtonTapped)
                    },
                    label: {
                        Text("Search")
                    }
                )
            }
            ScrollView {
                LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                    ForEach(store.searchResultList, id: \.self) { result in
                        Button(
                            action: {
                                send(.gifItemTapped(
                                    result.height200DownsampledURL,
                                    result.originalURL
                                ))
                            },
                            label: {
                                GifView(url: result.height100URL, attributionScale: 0.5)
                                    .frame(height: 100)
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 40)
    }
}
