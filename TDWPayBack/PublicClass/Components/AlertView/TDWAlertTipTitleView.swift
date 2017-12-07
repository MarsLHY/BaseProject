//
//  TDWAlertTipTitleView.swift
//  TDWKit_Example
//
//  Created by John on 2017/10/16.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

/**
 使用示例:
 let alert = TDWAlertTipView(msg: subTitle)
 alert.confirmClourse = confirmClosure
 alert.showAlertView(inViewController: inViewController)

使用注意: 一个按钮带标题, 可以设置富文本通过attributeTitle，attributeSubTitle，也可以自己获取到titleLabel、subTitlelable、confirmBtn自己修改
 */
open class TDWAlertTipTitleView: TDWAlertTipView {
    //标题
    open lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = UIColor(TDWValueRGB: 0x999999)
        label.numberOfLines = 0
        return label
    }()

    //虚线
    open lazy var imaginaryLine: TDWDashLine = {
        let line = TDWDashLine()
        return line
    }()

    open lazy var snpTempView: UIView = {
        let view = UIView()
        self.addSubview(view)
        return view
    }()

    open var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    open var attributeTitle: NSAttributedString? {
        didSet {
            guard attributeTitle != nil else {
                return
            }

            titleLabel.attributedText = attributeTitle
        }
    }

    convenience init(title: String, msg: String) {
        self.init(animationStyle: .TDWAlertFadePop, alertStyle: .TDWAlertStyleAlert)
        titleLabel.text = title
        subTitle = msg
        self.title = title
    }

    override open func prepareUI() {
        super.prepareUI()
        snpTempView.addSubview(titleLabel)
        addSubview(snpTempView)
        addSubview(imaginaryLine)
        confirmBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)

        imaginaryLine.snp.makeConstraints { (make) in
            make.top.equalTo(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalToSuperview().multipliedBy(0.8)
        }

        snpTempView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(imaginaryLine.snp.top)
        }

        titleLabel.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })

        subTextView.snp.remakeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-80)
            make.top.equalTo(snpTempView.snp.bottom).offset(30)
            textViewHCons = make.height.equalTo(TDWAlertView.maxLabelH)
        })

        confirmBtn.snp.remakeConstraints { (make) in
            make.top.equalTo(subTextView.snp.bottom).offset(30)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(40)
        }

        horizontalLine.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(confirmBtn.snp.top)
            make.height.equalTo(0.5)
        }

        layer.cornerRadius = 7.5
        layer.masksToBounds = true
    }
}
