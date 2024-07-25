//
//  View+.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/25.
//

import Foundation
import SwiftUI

extension View {
    func fullWidth() -> some View {
        frame(maxWidth: .infinity)
    }
    
    func apply<V: View>(@ViewBuilder _ block: (Self) -> V) -> V { block(self) }
}
