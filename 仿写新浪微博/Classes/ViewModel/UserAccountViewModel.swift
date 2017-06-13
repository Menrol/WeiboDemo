//
//  UserAccountViewModel.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/6/3.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import Foundation

class UserAccountViewModel {
    
    /// 单例
    static let sharedUersAccount:UserAccountViewModel = UserAccountViewModel()
    
    /// 模型
    var userAccount:UserAccount?
    
    /// 是否过期
    private var isExpired:Bool{
        if userAccount?.expires_date?.compare(Date()) == .orderedDescending {
            return false
        }
        
        return true
    }
    
    /// 是否登录
    var isLogin:Bool{
        return userAccount?.access_token != nil && !isExpired ? true:false
    }
    
    /// 授权的唯一票据
    var access_token:String?{
        if !isExpired {
            return userAccount?.access_token
        }
        
        return nil
    }
    
    /// 用户头像URL（大图），180×180像素
    var avatar_largeURL: URL{
        return URL(string: userAccount?.avatar_large ?? "")!
    }
    
    /// 路径
    fileprivate var accountpath: String{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        
        return (path as NSString).appendingPathComponent("useraccount.plist")
    }
    
    
    /// 构造函数
    private init() {
        // 从沙盒解档
        userAccount = NSKeyedUnarchiver.unarchiveObject(withFile: accountpath) as? UserAccount
        
        if isExpired == true {
            print("过期了")
            
            userAccount = nil
        }
    }
}

// MARK: - 网络处理
extension UserAccountViewModel{
    
    /// 加载access_token
    func loadAccessToken(code: String, finished:@escaping (_ isSuccess:Bool) -> Void){
        NetworkTool.sharedTool.loadAccessToken(code: code) { (result, error) in
            if error != nil{
                finished(false)
            }
            self.userAccount = UserAccount(dic: (result as? [String:Any])!)
            
            self.loadUserInfo(userAccount: self.userAccount!, finished: finished)
        }
    }
    
    /// 加载用户信息
    private func loadUserInfo(userAccount: UserAccount, finished:@escaping (_ isSuccess:Bool) -> Void){
        NetworkTool.sharedTool.loadUserInfo(uid: userAccount.uid!, finished: { (result, error) in
            
            print(result!)
            guard let dic = result as? [String:Any] else{
                finished(false)
                return
            }
            
            userAccount.screen_name = dic["screen_name"] as? String
            userAccount.avatar_large = dic["avatar_large"] as? String
            
            // 存储用户信息
            NSKeyedArchiver.archiveRootObject(userAccount, toFile: self.accountpath)
            finished(true)
        })
    }
}
