//
//  SignInViewController.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/03/16.
//

import UIKit

class SignInViewController: BaseViewController {
    private lazy var projectNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Gifscribe It"
        return label
    }()
    
    let idTextField = UITextField()
    
    let passwordTextField = UITextField()
    
    let signInButton = UIButton()
    
    let signUpButton = UIButton()

    let findButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func setLayout() {
        let stackView = UIStackView()
        stackView.addSubview(projectNameLabel)
        view.addSubview(stackView)
    }
}
