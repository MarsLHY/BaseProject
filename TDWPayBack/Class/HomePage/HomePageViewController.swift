//
//  HomePageViewController.swift
//  TDWPayBack
//
//  Created by lihaiyan on 2017/12/6.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import Foundation
import FDFullscreenPopGesture

class HomePageViewController: TDWBaseViewController {
    
    //transitionStyle:转换样式，有PageCurl和Scroll两种
    //navigationOrientation:导航方向，有Horizontal和Vertical两种
    //options: UIPageViewControllerOptionSpineLocationKey---书脊的位置
    //UIPageViewControllerOptionInterPageSpacingKey---每页的间距
    lazy var pageController: UIPageViewController = {
        return  UIPageViewController(transitionStyle: .scroll,
                                     navigationOrientation:.horizontal,
                                     options: [UIPageViewControllerOptionInterPageSpacingKey: NSNumber(value:0)])
    }()
    lazy var viewControllers:[UIViewController] = {
        return [testViewController(),
                PersonalViewController(),
                testcViewController()]
    }()
    
    var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = nil
        self.view.backgroundColor = UIColor.yellow
        let testbutton = UIButton(type: .custom)
        testbutton.addTarget(self, action: #selector(testAction), for: .touchUpInside)
        testbutton.setTitle("test", for: .normal)
        testbutton.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(testbutton)
        testbutton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(200)
            make.left.equalToSuperview().offset(100)
            make.height.width.equalTo(50)
        }
       
        //代理
        pageController.dataSource = self
        pageController.delegate = self
        //展示之前进行初始化第一个controller，单个显示放一个，两个显示则放两个，和样式有关
        pageController.setViewControllers([viewControllers[0]], direction: .forward, animated: false, completion: nil)
        
        //UIpageController必须放在Controlller container中
        self.addChildViewController(pageController)
        self.view.addSubview(pageController.view)
        pageController.view.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    func testAction() {
        let vc = PersonalViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: -- PageViewController Delegate
extension HomePageViewController: UIPageViewControllerDataSource,UIPageViewControllerDelegate{
    
    //-------------DataSource-----------------
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = viewControllers.index(of: viewController)
        guard index != nil else {
            return nil
        }
        
        if index! > 0 {
            index! -= 1
        } else {
            return nil
        }
        return viewControllers[index!]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = viewControllers.index(of: viewController)
        guard index != nil else {
            return nil
        }
        
        if index! < self.viewControllers.count - 1 {
            index! += 1
        } else {
            return nil
        }
        return viewControllers[index!]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageController.viewControllers?.count ?? 0
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentPage
    }
    
    
    //------------Delegate--------------
    //页面切换完毕
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, pageViewController.viewControllers != nil else {
            return
        }
        
        if pageViewController.viewControllers!.count > 0 {
            currentPage = viewControllers.index(of: pageViewController.viewControllers![0])!
        }
    }
    
}
