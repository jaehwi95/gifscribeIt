//
//  BaseViewController.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/03/16.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setLayout()
        setConstraints()
    }
    
    func setLayout() {
        // Override Layout
    }
    
    func setConstraints() {
        // Override Constraints
    }
}
