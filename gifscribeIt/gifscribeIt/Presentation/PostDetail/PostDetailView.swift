//
//  PostDetailView.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 7/25/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@ViewAction(for: PostDetailFeature.self)
struct PostDetailView: View {
    let store: StoreOf<PostDetailFeature>
    
    var body: some View {
        VStack(spacing: 40) {
            Text("Post Detail View")
        }
//        .navigationBarBackButtonHidden(true)
    }
}
