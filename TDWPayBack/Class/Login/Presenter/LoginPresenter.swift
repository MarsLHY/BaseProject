//
//  LoginPresenter.swift
//  TDWPayBack
//
//  Created lihaiyan on 2017/12/5.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import Foundation

class LoginPresenter {
    // Reference to the View (weak to avoid retain cycle).
    weak var view: LoginViewInterface?
    // Reference to the Interactor's interface.
    var wireFrame: LoginWireFrameInput?
    // Reference to the Router
    var interactor: LoginInteratorInput?
}

///MARK: LoginModuleInterface
extension LoginPresenter: LoginModuleInterface {
}

///MARK: LoginInteractorOutput
extension LoginPresenter: LoginInteractorOutput {
}
