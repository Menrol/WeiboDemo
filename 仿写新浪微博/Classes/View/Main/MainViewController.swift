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
            let view = ComposeSwitchView.composeSwitchView()
            view.show(completion: { [weak view] (className) in
                guard let className = className,
                    let cls = NSClassFromString(Bundle.main.namespace + "." + className) as? UIViewController.Type
                    else {
                        view?.closeAnimation()
                        return
                }
                
                let vc = cls.init()
                let nav = UINavigationController(rootViewController: vc)
                
                self.present(nav, animated: true, completion: {
                    view?.closeAnimation()
                })
            })
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
            if conut > 99 {
                self.tabBar.items?[0].badgeValue = "99+"
                UIApplication.shared.applicationIconBadgeNumber = 99
            }else {
                self.tabBar.items?[0].badgeValue = conut > 0 ? "\(conut)" : nil
                UIApplication.shared.applicationIconBadgeNumber = conut
            }
            
        }
    }
    
    // MARK: - 视图生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewControllers()
        setComposeButton()
        setupTimer()
        
        // 设置代理
        delegate = self
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

// MARK: - UITabBarControllerDelegate
extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // 获取将要切换控制器索引
        let idx = childViewControllers.index(of: viewController)
        
        // 判断是否是首页
        if selectedIndex == 0 && idx == selectedIndex {
            // 获取首页控制器
            let nav = childViewControllers[0] as! UINavigationController
            let vc = nav.childViewControllers[0] as! HomeTableViewController
            // 滚动到顶部
            vc.tableView.contentOffset = CGPoint(x: 0, y: -64)
            // 刷新
            delay(time: 0.1, execute: {
                vc.loadData(isPulldown: true)
            })
        }
        
        return !viewController.isMember(of: UIViewController.self)
    }
}

// MARK: - 设置界面
extension MainViewController{
    
    /// 设置添加按钮
    fileprivate func setComposeButton(){
        
        tabBar.addSubview(composeButton)
        
        // 调整按钮
        let count = childViewControllers.count
        let w = tabBar.bounds.width / CGFloat(count)
        let tabbarFrame = tabBar.bounds
        composeButton.frame = tabbarFrame.insetBy(dx: 2 * w, dy: 0)
        
        // 添加监听方法
        composeButton.addTarget(self, action: #selector(MainViewController.pressComposeButton), for: UIControlEvents.touchUpInside)
    }
    
    /// 添加所有子控制器
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
