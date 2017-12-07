//
//  TDWAlertTipVIew.swift
//  TDWKit_Example
//
//  Created by John on 2017/10/16.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import TDWAlertView
import SnapKit

/**
 使用示例:
 let alert = TDWAlertTipTitleView(title: title, msg: subTitle)
 alert.confirmClourse = confirmClosure
 alert.showAlertView(inViewController: inViewController)

 使用注意: 一个按钮不带标题, 可以设置富文本通过attributeSubTitle，也可以自己获取到subTitlelable、confirmBtn自己修改
 */
open class TDWAlertTipView: TDWAlertCommonView {

    //描述
    open lazy var subTextView: TDWTextView = {
        let textView = TDWTextView()
        textView.isScrollEnabled = true
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 17.0)
        textView.textColor = UIColor(TDWValueRGB: 0x333333)
        textView.textAlignment = .center
        textView.showsHorizontalScrollIndicator = false
        return textView
    }()

    open lazy var horizontalLine: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(TDWValueRGB: 0xe6e6e6)
        return view
    }()

    open lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(UIColor(TDWValueRGB: 0xfab600), for: .normal)
        return btn
    }()

    open var subTitle: String? {
        didSet {
            subTextView.text = subTitle
        }
    }

    open var attributeSubTitle: NSAttributedString? {
        didSet {
            guard attributeSubTitle != nil else {
                return
            }

            subTextView.attributedText = attributeSubTitle
        }
    }

    open var confirmButtonTitle: String? {
        didSet {
            confirmBtn.setTitle(confirmButtonTitle, for: .normal)
        }
    }

    open var confirmClourse: ( () -> Void )?
    var textViewHCons: ConstraintMakerEditable?

    override public init(animationStyle: TDWAlertAnimationStyle, alertStyle: TDWAlertStyle) {
        super.init(animationStyle: animationStyle, alertStyle: alertStyle)
        prepareUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience public init(msg: String) {
        self.init(animationStyle: .TDWAlertFadePop, alertStyle: .TDWAlertStyleAlert)
        subTitle = msg
        print(msg)
    }

    open func prepareUI() {
        backgroundColor = .white
        addSubview(subTextView)
        addSubview(horizontalLine)
        addSubview(confirmBtn)
        confirmBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)

        subTextView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-80)
            make.top.equalToSuperview().offset(30)
            textViewHCons = make.height.equalTo(TDWAlertView.maxLabelH)
        }

        confirmBtn.snp.makeConstraints { (make) in
            make.top.equalTo(subTextView.snp.bottom).offset(30)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(40)
        }

        horizontalLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(confirmBtn.snp.top)
            make.height.equalTo(0.5)
        }

        layer.cornerRadius = 7.5
        layer.masksToBounds = true
    }

    private func heightWithStr(_ str: String) -> CGFloat {
        let maxWidth = self.frame.size.width - 80

        let rect = str.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude),
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17.0)],
                                     context: nil)

        return rect.size.height + 17
    }

    private func heightWithAttrStr(_ attr: NSAttributedString) -> CGFloat {
        let maxWidth = self.frame.size.width - 80

        let size = attr.boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size

        return size.height + 17
    }

    open override func layoutSubviews() {
        super.layoutSubviews()


        if !String.tdw_isEmpty(subTitle) {
            let height = heightWithStr(subTitle!)
            let realHeight = height > TDWAlertView.maxLabelH ? TDWAlertView.maxLabelH : height
            textViewHCons?.constraint.update(offset: realHeight)
        }


        if !String.tdw_isEmpty(attributeSubTitle?.string) {
            let height = heightWithAttrStr(attributeSubTitle!)
            let realHeight = height > TDWAlertView.maxLabelH ? TDWAlertView.maxLabelH : height
            textViewHCons?.constraint.update(offset: realHeight)
        }
    }

    open func btnClick() {
        hiddenAlertView {[weak self] in
           self?.confirmClourse?()
        }
    }

    open func showAlertView(inViewController: UIViewController, leftOrRightMargin: CGFloat) {
        super.showAlertView(inViewController: inViewController, leftOrRightMargin: leftOrRightMargin)
    }

    open func showAlertView(inViewController: UIViewController) {
        showAlertView(inViewController: inViewController, leftOrRightMargin: 35)
    }
}

open class TDWTextView: UITextView {

    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        resignFirstResponder()
        isUserInteractionEnabled = false
        return false
    }
}
