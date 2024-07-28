//
//  LoadingWindow.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 7/29/24.
//

import Foundation
import SwiftUI
import UIKit

class LoadingWindow: UIWindow {
    static let shared = LoadingWindow(frame: UIScreen.main.bounds)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented: please use LoadingWindow.shared")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let loadingViewController = UIHostingController(rootView: LoadingView())
        loadingViewController.view?.backgroundColor = .clear
        self.rootViewController = loadingViewController
        self.isHidden = true
    }
    
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }
}
