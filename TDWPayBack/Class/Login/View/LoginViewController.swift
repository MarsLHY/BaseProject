//
//  LoginViewController.swift
//  TDWPayBack
//
//  Created lihaiyan on 2017/12/5.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    // Reference to the Presenter's interface.
    var presenter: LoginModuleInterface?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

///Mark: LoginInterface
extension LoginViewController: LoginViewInterface {
}
