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
class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        
        let rootView = RootView(
            store: Store(initialState: RootFeature.State()) {
                RootFeature()._printChanges()
            }
        )
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIHostingController(rootView: rootView)
        window?.makeKeyAndVisible()
        _ = LoadingWindow.shared
        
        return true
    }
}
