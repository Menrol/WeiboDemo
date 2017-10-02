//
//  MainViewController.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/5/20.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    /// 定时器
    fileprivate var timer: Timer?
    
    // MARK: - 监听方法
    @objc fileprivate func pressComposeButton() {
        if UserAccountViewModel.sharedUersAccount.isLogin {
            ComposeSwitchView.show()
        }else {
            let viewController = OAuthViewController()
            let nav = UINavigationController(rootViewController: viewController)
            present(nav, animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func checkUnreadCount() {
        NetworkTool.sharedTool.unreadCount { (result, error) in
            let dic = result as? [String: Any]
            let conut = dic?["status"] as? Int ?? 0
            print("未读数\(conut)")
            self.tabBar.items?[0].badgeValue = conut > 0 ? "\(conut)" : nil
            UIApplication.shared.applicationIconBadgeNumber = conut
        }
    }
    
    // MARK: - 视图生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewControllers()
        setComposeButton()
        setupTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tabBar.bringSubview(toFront: composeButton)
        
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - 懒加载控件
    fileprivate lazy var composeButton: UIButton = UIButton(imageName: "tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")

}

// MARK: - 时钟相关方法
extension MainViewController {
    fileprivate func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(checkUnreadCount), userInfo: nil, repeats: true)
    }
}

// MARK: - 设置界面
extension MainViewController{
    
    /// 设置添加按钮
    fileprivate func setComposeButton(){
        
        tabBar.addSubview(composeButton)
        
        // 调整按钮
        let count = childViewControllers.count
        let w = tabBar.bounds.width / CGFloat(count) - 1
        let tabbarFrame = tabBar.bounds
        composeButton.frame = tabbarFrame.insetBy(dx: 2 * w, dy: 0)
        
        // 添加监听方法
        composeButton.addTarget(self, action: #selector(MainViewController.pressComposeButton), for: UIControlEvents.touchUpInside)
    }
    
    fileprivate func addChildViewControllers() {
        addChildViewController(vc: HomeTableViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(vc: MessageTableViewController(), title: "信息", imageName: "tabbar_message_center")
        addChildViewController(UIViewController())
        addChildViewController(vc: DiscoverTableViewController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(vc: ProfileTableViewController(), title: "我", imageName: "tabbar_profile")
    }
    
    /// 添加控制器
    fileprivate func addChildViewController(vc:UIViewController,title:String,imageName:String) {
        vc.title = title
        vc.tabBarItem.image = UIImage(named: "\(imageName)")
        vc.tabBarItem.selectedImage = UIImage(named: "\(imageName)_selected")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let navi = UINavigationController(rootViewController: vc)
        addChildViewController(navi)
    }
}
