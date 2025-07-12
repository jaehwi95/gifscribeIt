//
//  LoadingWindow.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 7/29/24.
//

import Foundation
import SwiftUI
import UIKit

final class LoadingWindow: UIWindow {
    static let shared = LoadingWindow()
    
    private init() {
        super.init(frame: UIScreen.main.bounds)
        self.windowLevel = .alert + 1
        self.isHidden = true
        self.rootViewController = UIHostingController(rootView: LoadingView())
        self.rootViewController?.view.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented: please use LoadingWindow.shared")
    }
    
    func show() {
        DispatchQueue.main.async {
            self.isHidden = false
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.isHidden = true
        }
    }
}
