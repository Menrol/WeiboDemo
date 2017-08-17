//
//  Emoticon.swift
//  Emoticon
//
//  Created by Apple on 2017/8/11.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class Emoticon: NSObject {
    /// 发送给服务器字符串
    var chs: String?
    /// 本地图片
    var png: String?
    /// 表情十六进制编码
    var code: String? {
        didSet{
            emoji = code?.emoji
        }
    }
    /// 本地图片完整路径
    var path: String {
        if png == nil {
            return ""
        }
        
        return Bundle.main.bundlePath + "/Emoticons.bundle/" + png!
    }
    /// 是否是删除按钮
    var isDelete: Bool = false
    /// 是否是空白
    var isEmpty: Bool = false
    /// emoji字符串
    var emoji: String?
    
    init(isDelete: Bool) {
        self.isDelete = isDelete
    }
    
    init(isEmpty: Bool) {
        self.isEmpty = isEmpty
    }
    
    init(dictionary:[String: Any]) {
        super.init()
        
        setValuesForKeys(dictionary)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    override var description: String {
        let keys = ["chs","png","code"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
}
