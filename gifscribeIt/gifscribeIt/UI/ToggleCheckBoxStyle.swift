//
//  ToggleCheckBoxStyle.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/08/01.
//

import Foundation
import SwiftUI

struct ToggleCheckBoxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(
            action: {
                configuration.isOn.toggle()
            },
            label: {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                configuration.label
            }
        )
    }
}
