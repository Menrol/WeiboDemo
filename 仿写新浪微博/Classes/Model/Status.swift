//
//  Status.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/6/14.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class Status: NSObject {
    /// 微博ID
    var id: Int = 0
    /// 微博创建时间
    var created_at: String?
    /// 微博来源
    var source: String?
    /// 微博信息内容
    var text: String?
    /// 用户
    var user: User?
    /// 配图数组
    var pic_urls: [[String: String]]?
    /// 转发微博
    var retweeted_status: Status?
    
    init(dic: [String: Any]) {
        super.init()
        
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "user" {
            if let dic = value as? [String: Any] {
                user = User(dic: dic)
            }
            return
        }else if key == "retweeted_status"{
            if let dic = value as? [String: Any] {
                retweeted_status = Status(dic: dic)
            }
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    override var description: String{
        let keys = ["id","created_at","source","text","user","retweeted_status"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
}
