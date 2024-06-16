//
//  SplashViewController.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/03/16.
//

import UIKit

class SplashViewController: BaseViewController {
    let isSignedIn: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isSignedIn {
            self.navigationController?.pushViewController(SignInViewController(), animated: false)
        } else {
            
        }
    }
}
