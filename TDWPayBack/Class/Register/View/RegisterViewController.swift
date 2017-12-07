//
//  RegisterViewController.swift
//  TDWPayBack
//
//  Created lihaiyan on 2017/12/5.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    // Reference to the Presenter's interface.
    var presenter: RegisterModuleInterface?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

///Mark: RegisterInterface
extension RegisterViewController: RegisterViewInterface {
}
