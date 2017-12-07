//
//  RegisterWireFrame.swift
//  TDWPayBack
//
//  Created lihaiyan on 2017/12/5.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import Foundation

class RegisterWireFrame {

    private class func buildModule() -> RegisterViewController {
        ///viper模块间建立依懒
        let view = RegisterViewController()
        let presenter = RegisterPresenter()
        let interactor = RegisterInterator()
        let wireFrame = RegisterWireFrame()
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.wireFrame = wireFrame
        interactor.presenter = presenter
        return view
    }
}

extension RegisterWireFrame: RegisterWireFrameInput {
}
