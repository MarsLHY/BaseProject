//
//  TDWLoadingView.swift
//  TuanDaiV4
//
//  Created by ZhengRuSong on 2017/7/31.
//  Copyright © 2017年 Dee. All rights reserved.
//

import UIKit

class TDWLoadingView: UIView {
    
    var loadingStyle: TDWLoadingStyle?
    
    var contentView: UIView!
    var imageView: UIImageView!
    var titleLabel: UILabel!
    let viewHeight: CGFloat = 46.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configData(_ title: String?, style: TDWLoadingStyle) {
        
        if let title = title {
            if !title.isEmpty {
                titleLabel.text = title
            }else{
                titleLabel.text = "加载中"
            }
        }else{
            titleLabel.text = "加载中"
        }
        
        if loadingStyle != style {
            if style == .none {
                backgroundColor = .clear
                titleLabel.textColor = UIColor(red: 171.0/255.0, green: 171.0/255.0, blue: 171.0/255.0, alpha: 1.0)
            }else {
                backgroundColor = UIColor.black.withAlphaComponent(0.5)
                titleLabel.textColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
            }
            loadingStyle = style
        }
    }
    
    func startLoadingAnimation() {
        imageView.startAnimating()
    }
    
    func stopLoadingAnimation() {
        imageView.stopAnimating()
    }
    
    func loadingViewSize() -> CGSize {
        
        layoutIfNeeded()
        return CGSize(width: 50.0 + contentView.frame.width, height: viewHeight)
    }
    
    private func setup() {
        contentView = UIView()
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.height.equalTo(viewHeight)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        imageView = UIImageView()
        var imagesArray: [UIImage] = []
        imageView.image = UIImage(named: "loading_00")
        for i in 0..<51 {
            let imageName = String(format: "loading_%02d", i)
            let image = UIImage(named: imageName)
            if let image = image {
                imagesArray.append(image)
            }
        }
        imageView.animationImages = imagesArray
        imageView.animationDuration = 2.0
        imageView.animationRepeatCount = 0
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 20.0, height: 20.0))
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 12.0)
        titleLabel.textColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(13.0)
            make.centerY.equalTo(imageView)
            make.right.equalToSuperview()
        }
        
        layer.cornerRadius = 8.0
        clipsToBounds = true
    }
    
}

