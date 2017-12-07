//
//  TDWPopTwoView.swift
//  TDWKit
//
//  Created by John on 2017/10/9.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import TDWAlertView
import SnapKit

/**
 使用示例:
 let alert = TDWAlertChooseTitleView.init(title: title, msg: subTitle)
 alert.confirmClourse = confirmClosure
 alert.cancelClourse = cancleClosure
 alert.showAlertView(inViewController: inViewController)

 使用注意: 两个按钮不带标题, 可以设置富文本通过attributeSubTitle，也可以自己获取到subTitlelable、twoBtnView自己修改
 */
open class TDWAlertChooseView: TDWAlertCommonView {
    
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

    open lazy var twoBtnView: TDWTwoButtonView = {
        var twoBtnView = TDWTwoButtonView(leftTitle: "取消", rightTitle: "确定", lefeBlock: { [weak self] in
            self?.hiddenAlertView {
                self?.cancelClourse?()
            }
            }, rightBlock: { [weak self] in
                self?.hiddenAlertView {
                    self?.confirmClourse?()
                }
        })
        return twoBtnView
    }()

    open var subTitle: String? {
        didSet {
            subTextView.text = subTitle
        }
    }

    open var attributeSubTitle: NSAttributedString? {
        didSet {
            subTextView.attributedText = attributeSubTitle
        }
    }

    open var confirmButtonTitle: String? {
        didSet {
            twoBtnView.rightButton.setTitle(confirmButtonTitle, for: .normal)
        }
    }

    open var cancelButtonTitle: String? {
        didSet {
            twoBtnView.leftButton.setTitle(cancelButtonTitle, for: .normal)
        }
    }

    open var cancelClourse: ( () -> Void )?
    open var confirmClourse: ( () -> Void )?
    var textViewHCons: ConstraintMakerEditable?

    override init(animationStyle: TDWAlertAnimationStyle, alertStyle: TDWAlertStyle) {
        super.init(animationStyle: animationStyle, alertStyle: alertStyle)
        prepareUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience public init(msg: String) {
        self.init(animationStyle: .TDWAlertFadePop, alertStyle: .TDWAlertStyleAlert)
        subTextView.text = msg
        subTitle = msg
    }

    open func prepareUI() {
        backgroundColor = .white
        addSubview(subTextView)
        addSubview(twoBtnView)

        subTextView.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-80)
            make.top.equalToSuperview().offset(30)
            textViewHCons = make.height.equalTo(TDWAlertView.maxLabelH)
        })
        twoBtnView.snp.makeConstraints { (make) in
            make.top.equalTo(subTextView.snp.bottom).offset(30)
            make.left.right.bottom.equalToSuperview()
        }

        layer.cornerRadius = 7.5
        layer.masksToBounds = true
    }


    open func showAlertView(inViewController: UIViewController, leftOrRightMargin: CGFloat) {
        super.showAlertView(inViewController: inViewController, leftOrRightMargin: leftOrRightMargin)
    }

    open func showAlertView(inViewController: UIViewController) {
        showAlertView(inViewController: inViewController, leftOrRightMargin: 35)
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
}

///虚线类
open class TDWDashLine: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    override open func draw(_ rect: CGRect) {

        let dotteShapLayer = CAShapeLayer()
        let mdotteShapePath = CGMutablePath()
        dotteShapLayer.fillColor = UIColor.clear.cgColor
        dotteShapLayer.strokeColor = UIColor(TDWValueRGB: 0xd1d1d1).cgColor
        mdotteShapePath.move(to: CGPoint(x: rect.origin.x, y: rect.maxY / 2))
        mdotteShapePath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY / 2))
        dotteShapLayer.lineWidth = 1
        dotteShapLayer.lineJoin = kCALineJoinBevel
        dotteShapLayer.lineDashPattern =  [NSNumber.init(value: 3), NSNumber.init(value: 2)]
        dotteShapLayer.path = mdotteShapePath
        layer.addSublayer(dotteShapLayer)
    }
}
