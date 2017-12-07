//
//  TDWNavigationController.swift
//  TDWPayBack
//
//  Created by lihaiyan on 2017/12/4.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import Foundation
import UIKit

class TDWNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    // 设置是否允许Swipe返回。
    var canSwipeRightToGoBack: Bool = true
    
    // for hidding navigationBar bottom line.
    lazy var weakImageView: UIImageView? = {
        
        for view in self.navigationBar.subviews {
            for view2 in view.subviews {
                if let imageView = (view2 as? UIImageView) {
                    return imageView
                }
            }
        }
        return nil
    }()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = true;
        //先将手势去掉.
        //        self.addSwipeGestureRecognizer()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !viewControllers.isEmpty {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    
    private func addSwipeGestureRecognizer() {
        let swipe = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeRecognized(_:)))
        view.addGestureRecognizer(swipe)
        swipe.delegate = self
    }
    
    @objc private func swipeRecognized(_ gestureRecognizer: UISwipeGestureRecognizer) {
        
        if (gestureRecognizer.state == UIGestureRecognizerState.ended) &&
            (gestureRecognizer.direction == UISwipeGestureRecognizerDirection.right) &&
            canSwipeRightToGoBack {
            
            canSwipeRightToGoBack = false
            guard let view = gestureRecognizer.view else {
                canSwipeRightToGoBack = true
                return
            }
            if let _ = (view as? UIControl) {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5 , execute: {
                    self.canSwipeRightToGoBack = true
                })
                return
            }
            
            popViewController(animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5 , execute: {
                self.canSwipeRightToGoBack = true
            })
        }
    }
    
    
    // MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        guard let _ = gestureRecognizer.view else {
            return false
        }
        return true
    }
    
    //MARK: 屏幕旋转
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    
}

