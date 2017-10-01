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
    @objc var id: Int = 0
    /// 微博创建时间
    @objc var created_at: String?
    /// 微博来源
    @objc var source: String?
    /// 微博信息内容
    @objc var text: String?
    /// 用户
    @objc var user: User?
    /// 配图数组
    @objc var pic_urls: [[String: String]]?
    /// 转发微博
    @objc var retweeted_status: Status?
    /// 转发数
    @objc var reposts_count: Int = 0
    /// 评论数
    @objc var comments_count: Int = 0
    /// 表态数
    @objc var attitudes_count: Int = 0
    
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
