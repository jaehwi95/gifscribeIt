//
//  PayView.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/08/08.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@ViewAction(for: PayFeature.self)
struct PayView: View {
    let store: StoreOf<PayFeature>
    
    var body: some View {
        VStack(spacing: 40) {
            Button(
                action: {
                    send(.testPay(5000))
                },
                label: {
                    Text("Test Pay")
                }
            )
            Text("Pay View")
        }
    }
}
