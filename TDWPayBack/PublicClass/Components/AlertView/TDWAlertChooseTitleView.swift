//
//  TDWPopTitleTwoView.swift
//  TDWKit
//
//  Created by John on 2017/10/9.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import TDWAlertView
import TDWKit
/**
 使用示例:
 let alert = TDWAlertChooseView.init(msg: subTitle)
 alert.confirmClourse = confirmClosure
 alert.cancelClourse = cancleClosure
 alert.showAlertView(inViewController: inViewController)

 使用注意: 两个按钮带标题, 可以设置富文本通过attributeTitle，attributeSubTitle，也可以自己获取到titleLabel，subTitlelable、twoBtnView自己修改
 */
open class TDWAlertChooseTitleView: TDWAlertChooseView {
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
        var line = TDWDashLine()
        self.addSubview(line)
        return line
    }()

    open lazy var snpTempView: UIView = {
        var view = UIView()
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
            titleLabel.attributedText = attributeTitle
        }
    }

    override public init(animationStyle: TDWAlertAnimationStyle, alertStyle: TDWAlertStyle) {
        super.init(animationStyle: animationStyle, alertStyle: alertStyle)
        prepareUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(title: String, msg: String) {
        self.init(animationStyle: .TDWAlertFadePop, alertStyle: .TDWAlertStyleAlert)
        titleLabel.text = title
        subTextView.text = msg

        self.title = title
        self.subTitle = msg
    }

    override open func prepareUI() {
        super.prepareUI()
        snpTempView.addSubview(titleLabel)

        imaginaryLine.snp.makeConstraints { (make) in
            make.top.equalTo(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalToSuperview().multipliedBy(0.8)
        }

        snpTempView.snp.remakeConstraints { (make) in
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

        twoBtnView.snp.remakeConstraints { (make) in
            make.top.equalTo(subTextView.snp.bottom).offset(30)
            make.left.right.bottom.equalToSuperview()
        }

        layer.cornerRadius = 7.5
        layer.masksToBounds = true
    }
}
