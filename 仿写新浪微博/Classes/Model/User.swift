//
//  User.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/6/14.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class User: NSObject {
    
    /// 用户UID
    @objc var id: Int = 0
    /// 用户昵称
    @objc var screen_name: String?
    /// 用户头像地址（中图），50×50像素
    @objc var profile_image_url: String?
    /// 认证类型，-1：没有认证，0：认证用户 ，2,3,5：企业认证，220：达人
    @objc var verified_type: Int = 0
    /// 会员等级 0-6
    @objc var mbrank: Int = 0
    
    init(dic: [String: Any]) {
        super.init()
        
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    override var description: String{
        let keys = ["id","screen_name","profile_image_url","verified_type","mbrank"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
}
