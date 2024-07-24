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
        VStack(spacing: 40) {
            Text("Setting View")
            Form {
                Section("Title") {
                    TextField("Title", text: $store.title, axis: .vertical)
                        .lineLimit(2)
                }
                Section("Content") {
                    TextField("Content", text: $store.content, axis: .vertical)
                        .lineLimit(5...10)
                }
                Section("GIF") {
                    Button(
                        action: {
                        
                        }, label: {
                            Text("Search GIF")
                        }
                    )
                }
                Section("User") {
                    Text("Title")
                }
                Section("Date") {
                    Text("Date")
                }
            }
        }
    }
}
