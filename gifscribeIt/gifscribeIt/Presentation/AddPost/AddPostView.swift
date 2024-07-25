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
    
    var body: some View {
        Form {
            Section("Title*") {
                TextField("Title", text: $store.title, axis: .vertical)
                    .lineLimit(2)
            }
            Section("Content*") {
                TextField("Content", text: $store.content, axis: .vertical)
                    .lineLimit(5...10)
            }
            Section("GIF*") {
                Button(
                    action: {
                        send(.searchGifButtonTapped)
                    }, label: {
                        Text("Search GIF")
                    }
                )
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
                            }
                        )
                        Button(
                            action: {
                                send(.addPostButtonTapped)
                            },
                            label: {
                                Text("Add Post")
                            }
                        )
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
                Text("Sheet View")
            }
        }
    }
}
