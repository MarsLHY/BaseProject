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
    
    var pageController: UIPageViewController!
    var currentPage: Int = 0
    var viewControllers = NSMutableArray()
    
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
        //初始化
        //transitionStyle:转换样式，有PageCurl和Scroll两种
        //navigationOrientation:导航方向，有Horizontal和Vertical两种
        //options: UIPageViewControllerOptionSpineLocationKey---书脊的位置
        //UIPageViewControllerOptionInterPageSpacingKey---每页的间距
        pageController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionSpineLocationKey: NSNumber(value: 10)])
        
        //初始化要展示的VC
        for _ in 0...9 {
            let vc = PersonalViewController.init()
            viewControllers.add(vc)
        }
        //展示之前进行初始化第一个controller，单个显示放一个，两个显示则放两个，和样式有关
        if let abVC = viewControllers[0] as? [UIViewController] {
            pageController.setViewControllers(abVC, direction: .forward, animated: true, completion: nil)
        }
        
        //UIpageController必须放在Controlller container中
        self.addChildViewController(pageController)
        self.view.addSubview(pageController.view)
        currentPage = 0
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
        currentPage = currentPage - 1
        if currentPage < 0 {
            currentPage = 0
            return nil
        }
        return viewControllers[currentPage] as? UIViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        currentPage = currentPage + 1
        if currentPage > 9 {
            currentPage = 9
            return nil
        }
        return viewControllers[currentPage] as? UIViewController
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageController.viewControllers?.count ?? 0
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentPage
    }
    
    //------------Delegate--------------
    //    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
    //
    //    }
    //
    //    private func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
    //
    //    }
    //
    //    internal func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
    //        return .min
    //    }
    //
    //    private func pageViewControllerSupportedInterfaceOrientations(pageViewController: UIPageViewController) -> Int {
    //        return 2
    //    }
    //
    //    func pageViewControllerPreferredInterfaceOrientationForPresentation(_ pageViewController: UIPageViewController) -> UIInterfaceOrientation {
    //        return .portrait
    //    }
}
