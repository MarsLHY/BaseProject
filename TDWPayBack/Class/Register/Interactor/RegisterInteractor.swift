//
//  RegisterInteractor.swift
//  TDWPayBack
//
//  Created lihaiyan on 2017/12/5.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import Foundation

class RegisterInterator {
    // Reference to the Presenter's output interface(weak to avoid retain cycle).
    weak var presenter: RegisterInteractorOutput?
}

///MARK: RegisterInteratorInput
extension RegisterInterator: RegisterInteratorInput {
}
