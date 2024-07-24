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
                    Text("Home View")
                    Button("Test get search") {
                        send(.searchButtonTapped)
                    }
                    Button("Log Out") {
                        send(.logoutButtonTapped)
                    }
                }
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
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(
                        action: {
                            
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
