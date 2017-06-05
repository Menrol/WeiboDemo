//
//  UserAccount.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/6/3.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding{
    
    /// 授权的唯一票据
    var access_token:String?
    
    /// 生命周期,单位秒
    var expires_in:TimeInterval = 0{
        didSet{
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    
    /// 生命周期，时间
    var expires_date:NSDate?
    
    /// 授权用户的UID
    var uid:String?
    
    /// 用户昵称
    var screen_name:String?
    
    /// 用户头像地址（大图），180×180像素
    var avatar_large:String?
    
    init(dic: [String:Any]) {
        super.init()        
        
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String{
        let keys = ["access_token","expires_date","uid","screen_name","avatar_large"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
    
    // MARK: - 归档与解档
    // 解档
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? NSDate
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
    }
    
    // 归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(screen_name, forKey: "screen_name")
        aCoder.encode(avatar_large, forKey: "avatar_large")
    }
    
}
