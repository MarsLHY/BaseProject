//
//  RegisterPresenter.swift
//  TDWPayBack
//
//  Created lihaiyan on 2017/12/5.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import Foundation

class RegisterPresenter {
    // Reference to the View (weak to avoid retain cycle).
    weak var view: RegisterViewInterface?
    // Reference to the Interactor's interface.
    var wireFrame: RegisterWireFrameInput?
    // Reference to the Router
    var interactor: RegisterInteratorInput?
}

///MARK: RegisterModuleInterface
extension RegisterPresenter: RegisterModuleInterface {
}

///MARK: RegisterInteractorOutput
extension RegisterPresenter: RegisterInteractorOutput {
}
