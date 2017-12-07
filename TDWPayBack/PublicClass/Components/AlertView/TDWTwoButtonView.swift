//
//  TDWTwoButtonView.swift
//  TDWAlertViewController
//
//  Created by LuoJieFeng on 2017/7/26.
//  Copyright © 2017年 LuoJieFeng. All rights reserved.
//

import UIKit

/// 弹窗需要两个按钮时，请add这个View
/// 需要圆角需设置clipsToBounds和cornerRadius
open class TDWTwoButtonView: UIView {
    
    open var leftButtonBlock: (() -> Void)?
    open var rightButtonBlock: (() -> Void)?
    
    open lazy var horizontalLine: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(TDWValueRGB: 0xe6e6e6)
        return view
    }()
    
    open lazy var verticalLine: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(TDWValueRGB: 0xe6e6e6)
        return view
    }()
    
    open lazy var leftButton: UIButton = {
        var button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 17.0)
        button.setTitleColor(UIColor(TDWValueRGB: 0x999999), for: .normal)
        button.addTarget(self, action: #selector(leftButtonTouchAction), for: .touchUpInside)
        return button
    }()
    
    open lazy var rightButton: UIButton = {
        var button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        button.setTitleColor(UIColor(TDWValueRGB: 0xfab600), for: .normal)
        button.addTarget(self, action: #selector(rightButtonTouchAction), for: .touchUpInside)
        return button
    }()
    
    
    public init(leftTitle: String, rightTitle: String, lefeBlock: (() -> Void)?,rightBlock: (() -> Void)?) {
        super.init(frame: CGRect.zero)
        self.addSubview(horizontalLine)
        self.addSubview(verticalLine)
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        self.leftButtonBlock = lefeBlock
        self.rightButtonBlock = rightBlock
        self.leftButton.setTitle(leftTitle, for: .normal)
        self.rightButton.setTitle(rightTitle, for: .normal)
        horizontalLine.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.right.equalTo(self)
            make.height.equalTo(0.5)
        }
        verticalLine.snp.makeConstraints { (make) in
            make.top.equalTo(horizontalLine.snp.bottom)
            make.width.equalTo(0.5)
            make.bottom.equalTo(self)
            make.centerX.equalTo(self)
        }
        
        leftButton.snp.makeConstraints { (make) in
            make.top.equalTo(horizontalLine.snp.bottom)
            make.left.equalTo(self)
            make.right.equalTo(verticalLine.snp.left)
            make.height.equalTo(44)
            make.bottom.equalTo(self)
        }
        
        rightButton.snp.makeConstraints { (make) in
            make.top.equalTo(horizontalLine.snp.bottom)
            make.left.equalTo(verticalLine.snp.right)
            make.right.equalTo(self)
            make.height.equalTo(leftButton)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func leftButtonTouchAction() {
        leftButtonBlock?()
    }
    
    open func rightButtonTouchAction() {
        rightButtonBlock?()
    }
    
}
