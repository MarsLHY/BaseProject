//
//  TDWEmotionMap.swift
//  TDWPayBack
//
//  Created by lihaiyan on 2017/12/5.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


extension UIView {
    
    /// 显示网络请求不成功的情感图
    /// failure: 请求失败的模型
    /// position: 情感图的位置. 全屏情感图选择.top，局部情感图选择.middle
    /// topSpace: 图片距离顶部的距离
    /// tapClourse: 点击情感图的回调
    @discardableResult
    func tdw_showEmotionMap(
        failure: TDWFailureProtocol,
        position: EmotionMapPosition = .top,
        topSpace: CGFloat = 0.0,
        tapClourse: (() -> Void)? = nil) -> UIView? {
        return tdw_showEmotionMap(style: .map,
                                  failure: failure,
                                  position: position,
                                  topSpace: topSpace,
                                  tapClourse: tapClourse)
    }
    
    /// 显示网络请求不成功的情感图 HUD样式。
    /// failure: 请求失败的模型
    func tdw_showEmotionMapHUD(_ failure: TDWFailureProtocol) {
        tdw_showEmotionMap(style: .hud, failure: failure)
    }
    
    /// 显示无记录的情感图
    /// position: 情感图的位置
    /// tapClourse: 点击情感图的回调
    @discardableResult
    func tdw_showEmptyDataEmotionMap(position: EmotionMapPosition = .top,
                                     topSpace: CGFloat = 0.0,
                                     tapClourse: (() -> Void)? = nil) -> UIView? {
        return tdw_showEmotionMap(UIImage(named: CommonMapImageName.noData),
                                  title: CommonMapTitle.noData,
                                  text: CommonMapSubTitle,
                                  position: position,
                                  topSpace: topSpace,
                                  tapClourse: tapClourse)
    }
    
    /// add the view of emotion map to self.
    ///
    /// - parameter image: emotion map image.
    /// - parameter title: emotion title.
    /// - parameter text:  detail describle for example '点击屏幕,重新加载'.
    /// - parameter position: full emotion map select '.top' , half emotion map select '.middle' , '.top' by default.
    /// - parameter tapClourse: Called after emotion map has taped. Emotion map cannot be taped if tapAction is 'nil'.
    /// - Return emotionMapView ,you can disign subviews by yourself.
    @discardableResult
    func tdw_showEmotionMap(_ image: UIImage?,
                            title: String,
                            text: String?,
                            position: EmotionMapPosition = .top,
                            topSpace: CGFloat = 0.0,
                            tapClourse: (() -> Void)? = nil) -> UIView {
        
        if let map = self.tdw_emotionMap {
            //移除外部自定义视图。
            for view in map.subviews {
                if view != map.contentView {
                    view.removeFromSuperview()
                }
            }
            map.loadingView.stopLoadingAnimation()
            map.loadingView.isHidden = true
            map.titleLabel.isHidden = false
            map.textLabel.isHidden = false
            map.imageView.image = image
            map.titleLabel.text = title
            map.textLabel.text = text
            map.tapClourse = tapClourse
            return map
        }else {
            let map = TDWEmotionMap(contentPosition: position, topSpace: topSpace)
            map.backgroundColor = .white
            map.imageView.image = image
            map.titleLabel.text = title
            map.textLabel.text = text
            self.addSubview(map)
            self.tdw_emotionMap = map
            map.snp.makeConstraints { (make) in
                make.top.left.bottom.right.equalToSuperview()
            }
            // 滚动视图...
            if let _ =  self as? UIScrollView {
                map.snp.makeConstraints({ (make) in
                    make.width.equalTo(self).priority(.low)
                    make.height.equalTo(self).priority(.low)
                })
            }
            map.tapClourse = tapClourse
            return map
        }
    }
    /// 显示指定的情感图
    @discardableResult
    func tdw_showDesignedEmotionMap(_ emotionType: TDWEmotionMapType,
                                    position: EmotionMapPosition = .top,
                                    topSpace: CGFloat = 0.0,
                                    tapClourse: (() -> Void)? = nil) -> UIView {
        
        var image: UIImage?
        var title: String?
        var text: String?
        switch emotionType {
        case .networkError:
            title = CommonMapTitle.badNetwork
            image = UIImage(named: CommonMapImageName.noNetwork)
        default: //默认服务器错误
            title = CommonMapTitle.serverError
            image = UIImage(named: CommonMapImageName.serverError)
        }
        if tapClourse != nil {
            text = CommonMapSubTitle
        }
        return tdw_showEmotionMap(image,
                                  title: title!,
                                  text: text,
                                  position: position,
                                  topSpace: topSpace,
                                  tapClourse: tapClourse)
    }
    
    
    // 隐藏情感图
    func tdw_hideEmotionMap() {
        
        self.tdw_emotionMap?.removeFromSuperview()
        self.tdw_emotionMap = nil;
    }
    
    /// 视图上是否存在情感图
    func tdw_existEmotionMap() -> Bool {
        return tdw_emotionMap != nil
    }
}

extension UIView {
    
    private struct AssociatedKeys {
        static var key_emotionMap = "emotionMapKey"
    }
    fileprivate var tdw_emotionMap: TDWEmotionMap? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.key_emotionMap) as? TDWEmotionMap
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.key_emotionMap,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @discardableResult
    fileprivate func tdw_showEmotionMap(
        style: EmotionMapStyle,
        failure: TDWFailureProtocol,
        position: EmotionMapPosition = .top,
        topSpace: CGFloat = 0.0,
        tapClourse: (() -> Void)? = nil) -> UIView? {
        
        var errorCode = TDWServerCode.serverError
        if let code = failure.code {
            let code2 = TDWServerCode(rawValue: code)
            if let code2 = code2 {
                errorCode = code2
            }
        }
        
        var image: UIImage?
        var title: String?
        var text: String?
        switch errorCode {
        case .networkError:
            title = CommonMapTitle.badNetwork
            image = UIImage(named: CommonMapImageName.noNetwork)
        default: //默认服务器错误
            title = CommonMapTitle.serverError
            image = UIImage(named: CommonMapImageName.serverError)
        }
        if tapClourse != nil {
            text = CommonMapSubTitle
        }
        
        switch style {
        case .map:
            return tdw_showEmotionMap(image,
                                      title: title!,
                                      text: text,
                                      position: position,
                                      topSpace: topSpace,
                                      tapClourse: tapClourse)
        case .hud:
            self.tdw_showAutoHideHud(hudTitle: failure.msg,
                                     hideAfter: 2.0,
                                     userInteraction: true)
        }
        return nil
    }
}


class TDWEmotionMap: UIView {
    
    // 是否可以点击
    var validTap = true
    var contentPosition: EmotionMapPosition = .top
    var topSpace: CGFloat = 0
    var tapClourse: (()->Void)? {
        didSet{
            if tapClourse != nil {
                validTap = true
                textLabel.isHidden = false
            }else{
                validTap = false
                textLabel.isHidden = true
            }
        }
    }
    fileprivate lazy var contentView = {
        () -> UIView in
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var imageView = {
        () -> UIImageView in
        let view = UIImageView()
        view.contentMode = UIViewContentMode.scaleAspectFit
        return view
    }()
    
    fileprivate lazy var titleLabel = {
        () -> UILabel in
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 17.0)
        titleLabel.textColor = UIColor(TDWValueRGB: 0x212121)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    fileprivate lazy var textLabel = {
        () -> UILabel in
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0)
        label.textColor = UIColor(TDWValueRGB: 0xababab)
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var loadingView = {
        () -> TDWLoadingView in
        let loadingView = TDWLoadingView()
        loadingView.configData("加载中...", style: .none)
        loadingView.isHidden = true
        return loadingView
    }()
    
    convenience init(contentPosition position: EmotionMapPosition = .top, topSpace space: CGFloat = 0) {
        self.init(frame: CGRect.zero)
        contentPosition = position
        topSpace = space
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private  func setup() {
        addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(textLabel)
        contentView.addSubview(loadingView)
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(textLabel.snp.bottom).offset(0)
            if topSpace == 0 {
                if contentPosition == .top {
                    make.top.equalTo(self).offset(70.0)
                }else if contentPosition == .middle {
                    make.centerY.equalToSuperview()
                }
            }else{
                make.top.equalToSuperview().offset(70+topSpace)
            }
        }
        
        //image size
        imageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 141.0, height: 120.0))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(35.0)
        }
        textLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(15.0)
        }
        
        loadingView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(46.0)
            make.top.equalTo(imageView.snp.bottom).offset(35.0)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }
    
    // tap事件
    @objc private func handleTap() {
        if !validTap {
            return
        }
        if let cloure = tapClourse {
            validTap = false
            titleLabel.isHidden = true
            textLabel.isHidden = true
            loadingView.isHidden = false
            loadingView.startLoadingAnimation()
            cloure()
        }
    }
}

