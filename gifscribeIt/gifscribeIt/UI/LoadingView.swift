//
//  LoadingView.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 7/29/24.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
        }
        .fullWidth()
        .fullHeight()
        .background(.ultraThinMaterial.opacity(0.5))
    }
}
