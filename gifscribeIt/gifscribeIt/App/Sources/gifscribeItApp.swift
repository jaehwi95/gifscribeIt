//
//  gifscribeItApp.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/18.
//

import SwiftUI
import ComposableArchitecture
import FirebaseCore

@main
final class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        configureFirebase()
        setupRootWindow()
        return true
    }
}

private extension AppDelegate {
    func configureFirebase() {
        FirebaseApp.configure()
    }
    
    func setupRootWindow() {
        let rootView = RootView(
            store: Store(initialState: RootFeature.State()) {
                RootFeature()
            }
        )
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: rootView)
        window.makeKeyAndVisible()
        self.window = window
    }
}
