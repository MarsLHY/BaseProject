//
//  LoginWireFrame.swift
//  TDWPayBack
//
//  Created lihaiyan on 2017/12/5.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import Foundation

class LoginWireFrame {

    private class func buildModule() -> LoginViewController {
        ///viper模块间建立依懒
        let view = LoginViewController()
        let presenter = LoginPresenter()
        let interactor = LoginInterator()
        let wireFrame = LoginWireFrame()
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.wireFrame = wireFrame
        interactor.presenter = presenter
        return view
    }
}

extension LoginWireFrame: LoginWireFrameInput {
}
