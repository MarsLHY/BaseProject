//
//  TDWAlertCloseView.swift
//  TDWAlertView_Example
//
//  Created by John on 2017/11/28.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import TDWAlertView
import SnapKit

class TDWAlertCloseView: TDWAlertCommonView {

    // 描述
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 7.5
        view.layer.masksToBounds = true
        self.addSubview(view)
        return view
    }()

    // 存放TitleLabel
    open lazy var titleContentView: UIView = {
        let view = UIView()
        self.contentView.addSubview(view)
        return view
    }()

    // 标题
    open lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = UIColor(TDWValueRGB: 0x999999)
        label.numberOfLines = 0
        self.titleContentView.addSubview(label)
        return label
    }()

    // 虚线
    open lazy var imaginaryLine: TDWDashLine = {
        let line = TDWDashLine()
        line.isHidden = true
        self.contentView.addSubview(line)
        return line
    }()

    // 描述文字
    open lazy var subTextView: TDWTextView = {
        let textView = TDWTextView()
        textView.isScrollEnabled = true
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 17.0)
        textView.textColor = UIColor(TDWValueRGB: 0x333333)
        textView.textAlignment = .center
        textView.showsHorizontalScrollIndicator = false
        textView.isHidden = true
        self.contentView.addSubview(textView)
        return textView
    }()

    // 关闭按钮
    open lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        let image = UIImage(named: "home_window_close")
        btn.setImage(image, for: .normal)
        self.addSubview(btn)
        return btn
    }()

    // 遮罩
    open lazy var maskImageView: UIImageView = {
        let imageV = UIImageView()
        let image = UIImage(named: "find_loan_details_window_masking")
        imageV.image = image
        self.contentView.addSubview(imageV)
        return imageV
    }()


    open var title: String? {
        didSet {
            titleLabel.text = title
            
            let isEmpty = String.tdw_isEmpty(title)
            let offset = isEmpty ? 0 : 40
            titleViewHCons?.constraint.update(offset: offset)
            titleContentView.isHidden = isEmpty
            imaginaryLine.isHidden = isEmpty
        }
    }

    open var attributeTitle: NSAttributedString? {
        didSet {
            titleLabel.attributedText = attributeTitle

            let isEmpty = String.tdw_isEmpty(attributeTitle?.string)
            let offset = isEmpty ? 0 : 40
            titleViewHCons?.constraint.update(offset: offset)
            titleContentView.isHidden = isEmpty
            imaginaryLine.isHidden = isEmpty
        }
    }

    open var subTitle: String? {
        didSet {
            subTextView.text = subTitle

            subTextView.isHidden = String.tdw_isEmpty(subTitle)
        }
    }

    open var attributeSubTitle: NSAttributedString? {
        didSet {
            subTextView.attributedText = attributeSubTitle

            subTextView.isHidden = String.tdw_isEmpty(attributeSubTitle?.string)
        }
    }

    open var closeClourse: ( () -> Void )?
    var textViewHCons: ConstraintMakerEditable?
    var titleViewHCons: ConstraintMakerEditable?

    override public init(animationStyle: TDWAlertAnimationStyle, alertStyle: TDWAlertStyle) {
        super.init(animationStyle: animationStyle, alertStyle: alertStyle)
        prepareUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(title: String? = nil, msg: String? = nil) {
        self.init(animationStyle: .TDWAlertFadePop, alertStyle: .TDWAlertStyleAlert)
        titleLabel.text = title
        subTextView.text = msg
        self.subTitle = msg
        self.title = title
    }

    open func prepareUI() {
        backgroundColor = .clear
        closeBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
        }

        closeBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.centerX.bottom.equalToSuperview()
            make.top.equalTo(self.contentView.snp.bottom).offset(30)
        }

        // contentView
        titleContentView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            titleViewHCons = make.height.equalTo(0)
            make.bottom.equalTo(imaginaryLine.snp.top)
        }
        titleLabel.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })


        imaginaryLine.snp.makeConstraints { (make) in
            make.top.equalTo(titleContentView.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalToSuperview().multipliedBy(0.8)
        }

        subTextView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-50)
            make.top.equalTo(imaginaryLine.snp.bottom).offset(30)
            textViewHCons = make.height.equalTo(TDWAlertView.maxLabelH)
            make.bottom.equalToSuperview().offset(-30)
        }

        maskImageView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
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
            let shouldHidden = !(height > TDWAlertView.maxLabelH)
            maskImageView.isHidden = shouldHidden
        }
        
        if !String.tdw_isEmpty(attributeSubTitle?.string) {
            
            let height = heightWithAttrStr(attributeSubTitle!)
            let realHeight = height > TDWAlertView.maxLabelH ? TDWAlertView.maxLabelH : height
            textViewHCons?.constraint.update(offset: realHeight)
            let shouldHidden = !(height > TDWAlertView.maxLabelH)
            maskImageView.isHidden = shouldHidden
        }
    }

    open func btnClick() {
        hiddenAlertView {[weak self] in
            self?.closeClourse?()
        }
    }

    open func showAlertView(inViewController: UIViewController, leftOrRightMargin: CGFloat) {
        super.showAlertView(inViewController: inViewController, leftOrRightMargin: leftOrRightMargin)
    }

    open func showAlertView(inViewController: UIViewController) {
        showAlertView(inViewController: inViewController, leftOrRightMargin: 35)
    }
}
