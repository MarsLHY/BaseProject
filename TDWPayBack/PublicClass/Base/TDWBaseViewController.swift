//
//  TDWBaseViewController.swift
//  TDWPayBack
//
//  Created by lihaiyan on 2017/12/4.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import Foundation
import UIKit
import TDWKit

class TDWBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        edgesForExtendedLayout = .all
        view.backgroundColor = .white
        forceToSetBackItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarBackgroundImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("当前所在控制器：\n\(NSStringFromClass(type(of: self)).components(separatedBy: ".").last!)")
    }
    
    private func forceToSetBackItem() {
        
        let leftBarButton = UIButton(type: .custom)
        leftBarButton.setImage(UIImage(named: "navi_back"), for: .normal)
        leftBarButton.setTitleColor(UIColor.gray, for: .highlighted)
        leftBarButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        leftBarButton.frame = CGRect(x: 0, y: 0, width: 24, height: 41)
        leftBarButton.addTarget(self, action: #selector(popWithAnimate), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
    }
    
    func popWithAnimate() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: 设置导航条的颜色
    private func setupNavigationBarBackgroundImage() {
        
        
        guard let nav = navigationController else {
            return
        }
        if let TDWNav = nav as? TDWNavigationController  {
            
            nav.navigationBar.setBackgroundImage(nil, for: .default)
            TDWNav.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 20),
                                                        NSForegroundColorAttributeName: UIColor.black]
            if TDWNav.viewControllers.count == 1 {
                TDWNav.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
                TDWNav.weakImageView?.isHidden = true
                TDWNav.navigationBar.barTintColor = .white
            }else{
                TDWNav.weakImageView?.isHidden = false
                TDWNav.navigationBar.barTintColor = UIColor(TDWValueRGB: 0xfcfcfc)
            }
            TDWNav.navigationBar.isTranslucent = false
            return
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}

