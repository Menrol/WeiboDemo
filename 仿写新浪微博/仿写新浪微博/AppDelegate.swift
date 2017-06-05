//
//  AppDelegate.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/5/20.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupApperence()
        
        // 测试解档
        print(UserAccountViewModel.sharedUersAccount.userAccount)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = NewfeatureCollectionViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    // 设置全局外观
    private func setupApperence(){
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.orange], for: UIControlState.selected)
        UINavigationBar.appearance().tintColor = UIColor.orange
    }

}

