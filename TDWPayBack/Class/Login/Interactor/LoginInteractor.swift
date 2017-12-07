//
//  LoginInteractor.swift
//  TDWPayBack
//
//  Created lihaiyan on 2017/12/5.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import Foundation

class LoginInterator {
    // Reference to the Presenter's output interface(weak to avoid retain cycle).
    weak var presenter: LoginInteractorOutput?
}

///MARK: LoginInteratorInput
extension LoginInterator: LoginInteratorInput {
}
