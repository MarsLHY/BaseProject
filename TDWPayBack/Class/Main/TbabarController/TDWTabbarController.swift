//
//  TDWTabbarController.swift
//  TDWPayBack
//
//  Created by lihaiyan on 2017/12/4.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import Foundation
import UIKit

class TDWTabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var viewControllers: Array<UIViewController> = []
        let loanController = HomePageViewController()
        let meController = PersonalViewController()
        viewControllers.append(loanController)
        viewControllers.append(meController)
        let title = ["首页","个人中心"]
        let normalImage = ["loan_tool_loan_off","loan_tool_my_off"]
        let selectedImage = ["loan_tool_loan_on","loan_tool_my_on"]
        for (index, viewController) in viewControllers.enumerated() {
            viewController.tabBarItem.title = title.tdw_Element(at: index)
            let image = UIImage(named: normalImage.tdw_Element(at: index) ?? "")
            let selectedImage = UIImage(named: selectedImage.tdw_Element(at: index) ?? "")
            viewController.tabBarItem.image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            viewController.tabBarItem.selectedImage = selectedImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            let normalAttrDic: [String: Any] = [NSForegroundColorAttributeName: UIColor(TDWValueRGB:0x999999),
                                                NSFontAttributeName: UIFont.systemFont(ofSize: 10)]
            viewController.tabBarItem.setTitleTextAttributes(normalAttrDic, for: UIControlState.normal)
            let selectedAttrDic: [String: Any] = [NSForegroundColorAttributeName: UIColor(TDWValueRGB:0xffb700),
                                                  NSFontAttributeName: UIFont.systemFont(ofSize: 10)]
            viewController.tabBarItem.setTitleTextAttributes(selectedAttrDic, for: UIControlState.selected)
            viewController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
            viewController.tabBarItem.imageInsets = UIEdgeInsets(top: -2, left: 0, bottom: 2, right: 0)
            
        }
        //        self.viewControllers = [TDWNavigationController(rootViewController: loanController),
        //                                TDWNavigationController(rootViewController: investController),
        //                                TDWNavigationController(rootViewController: meController)]
        self.viewControllers = [TDWNavigationController(rootViewController: loanController),
                                TDWNavigationController(rootViewController: meController)]
        
        tabBar.barTintColor = .white
        //去掉bar顶部的线条
        tabBar.barStyle = .black
        
        //设置阴影
        tabBar.layer.shadowColor = UIColor(TDWValueRGB: 0xe5e5e5).cgColor
        tabBar.layer.shadowRadius = 4
        tabBar.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: tabBar.frame.height)).cgPath
        tabBar.layer.shadowOpacity = 0.9
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let tabIndex = tabBar.items?.index(of: item)
        //选中‘我’时无动画隐藏导航栏
        if tabIndex == 1 {
            let myVC:UINavigationController = viewControllers?[tabIndex!] as! UINavigationController;
            if myVC.isKind(of: UINavigationController.self) {
                myVC.setNavigationBarHidden(true, animated: false)
            }
        }
    }
}

