//
//  LoginProtocols.swift
//  TDWPayBack
//
//  Created lihaiyan on 2017/12/5.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import Foundation

/*
 * Protocol that defines the view input methods.
 */
protocol LoginViewInterface: class {
}

/*
 * Protocol that defines the commands sent from the View to the Presenter.
 */
protocol LoginModuleInterface: class {
}

/*
 * Protocol that defines the commands sent from the Interactor to the Presenter.
 */
protocol LoginInteractorOutput: class {
}

/*
 * Protocol that defines the Interactor's use case.
 */
protocol LoginInteratorInput: class {
}

/*
 * Protocol that defines the possible routes.
 */
protocol LoginWireFrameInput: class {
}
