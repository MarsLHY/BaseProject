//
//  TDWPhotoAlbumGuideViewController.swift
//  TuanDaiV4
//
//  Created by John on 2017/11/8.
//  Copyright © 2017年 Dee. All rights reserved.
//

import Foundation
import UIKit

class TDWPhotoAlbumGuideViewController: TDWBaseViewController {
    var isCameraGuide: Bool = false

    lazy fileprivate var guideImageView: UIImageView = {
        var imageV = UIImageView()

        return imageV
    }()

    lazy fileprivate var mainScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        return scrollView
    }()

    convenience init(_ isCameraGuide: Bool) {
        self.init(nibName: nil, bundle: nil)
        self.isCameraGuide = isCameraGuide
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        setData()
    }

    fileprivate func setData(){
        var imageName: String?

        if isCameraGuide {
            title = "开启相机步骤"
            if UIDevice.tdw_isIphone6 {
                imageName = "Wealth_Details_Open_Camera6"
            }else if UIDevice.tdw_isIphone6Plus {
                imageName = "Wealth_Details_Open_Camera6p"
            }else {
                imageName = "Wealth_Details_Open_Camera5s"
            }

        }else {
            title = "开启本地相册步骤"
            if UIDevice.tdw_isIphone6 {
                imageName = "wealth_details_open_gallery6"
            }else if UIDevice.tdw_isIphone6Plus {
                imageName = "wealth_details_open_gallery6p"
            }else {
                imageName = "wealth_details_open_gallery5s"
            }
        }
        
        guard let image = imageName else {
            return
        }
        guideImageView.image = UIImage(named: image)
    }

    fileprivate func setupUI(){
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(guideImageView)


        mainScrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        guideImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview()
        }
    }
}
