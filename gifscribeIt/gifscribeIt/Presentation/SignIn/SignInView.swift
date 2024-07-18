//
//  SignInView.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/18.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct SignInView: View {
    let store: StoreOf<SignInFeature>
    
    var body: some View {
        VStack {
            Text("Sign In View")
            Button("Navigate To Main") {
                store.send(.navigateToMain)
            }
        }
    }
}
