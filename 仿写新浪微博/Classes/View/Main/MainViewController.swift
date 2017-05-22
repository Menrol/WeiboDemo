//
//  MainViewController.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/5/20.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    fileprivate lazy var composeButton: UIButton = UIButton(imageName: "tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewControllers()
        setComposeButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tabBar.bringSubview(toFront: composeButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: - 设置界面
extension MainViewController{
    
    fileprivate func setComposeButton(){
        
        tabBar.addSubview(composeButton)
        
        //调整按钮
        let count = childViewControllers.count
        let w = tabBar.bounds.width / CGFloat(count) - 1
        let tabbarFrame = tabBar.bounds
        composeButton.frame = tabbarFrame.insetBy(dx: 2 * w, dy: 0)
    }
    
    fileprivate func addChildViewControllers() {
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.orange], for: UIControlState.selected)
        
        addChildViewController(vc: HomeTableViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(vc: MessageTableViewController(), title: "信息", imageName: "tabbar_message_center")
        addChildViewController(UIViewController())
        addChildViewController(vc: DiscoverTableViewController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(vc: ProfileTableViewController(), title: "我", imageName: "tabbar_profile")
        
    }
    
    //添加控制器
    fileprivate func addChildViewController(vc:UIViewController,title:String,imageName:String) {
        
        vc.title = title
        vc.tabBarItem.image = UIImage(named: "\(imageName)")
        vc.tabBarItem.selectedImage = UIImage(named: "\(imageName)_highlighted")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let navi = UINavigationController(rootViewController: vc)
        addChildViewController(navi)
        
    }
}
