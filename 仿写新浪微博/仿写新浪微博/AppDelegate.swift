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
    
        // 取得用户授权显示通知
        let notificationSettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        
//        // 测试
//        print(UserAccountViewModel.sharedUersAccount.userAccount as Any)
//        print(Bundle.main.infoDictionary)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        //注册通知
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: WBSwitchRootViewControllerNotification), object: nil, queue: nil) { (notification) in
            let viewController = notification.object == nil ? MainViewController() : WelcomeViewController()
            self.window?.rootViewController = viewController
        }
        
        return true
    }
    
    /// 进入后台
    func applicationDidEnterBackground(_ application: UIApplication) {
        StatusDAL.cleanCache()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(WBSwitchRootViewControllerNotification), object: nil)
    }
    
    // MARK: - 设置全局外观
    private func setupApperence(){
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.orange], for: UIControlState.selected)
        UINavigationBar.appearance().tintColor = UIColor.orange
    }

}

// MARK: - 界面切换代码
extension AppDelegate{
    
    /// 根视图
    fileprivate var rootViewController: UIViewController{
        if UserAccountViewModel.sharedUersAccount.isLogin {
            return isNewVersion ? NewfeatureCollectionViewController() : WelcomeViewController()
        }
        
        return isNewVersion ? MainViewController() : MainViewController()
    }

    /// 是否有新版本
    fileprivate var isNewVersion: Bool{
        // 获取当前版本
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let currentVersion = Double(version)!
        print(currentVersion)
        
        // 获取之前版本
        let versionMessage = "versionMessage"
        let preVersion = UserDefaults.standard.double(forKey: versionMessage)
        print(preVersion)
        
        // 保存当前版本
        UserDefaults.standard.set(currentVersion, forKey: versionMessage)
        
        return currentVersion > preVersion
    }
    
    
}

