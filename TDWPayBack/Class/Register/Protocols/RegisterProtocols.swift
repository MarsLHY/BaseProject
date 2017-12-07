//
//  RegisterProtocols.swift
//  TDWPayBack
//
//  Created lihaiyan on 2017/12/5.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import Foundation

/*
 * Protocol that defines the view input methods.
 */
protocol RegisterViewInterface: class {
}

/*
 * Protocol that defines the commands sent from the View to the Presenter.
 */
protocol RegisterModuleInterface: class {
}

/*
 * Protocol that defines the commands sent from the Interactor to the Presenter.
 */
protocol RegisterInteractorOutput: class {
}

/*
 * Protocol that defines the Interactor's use case.
 */
protocol RegisterInteratorInput: class {
}

/*
 * Protocol that defines the possible routes.
 */
protocol RegisterWireFrameInput: class {
}
