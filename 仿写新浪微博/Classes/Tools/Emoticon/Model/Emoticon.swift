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
    @objc var chs: String?
    /// 本地图片
    @objc var png: String?
    /// 表情十六进制编码
    @objc var code: String? {
        didSet{
            emoji = code?.emoji
        }
    }
    /// 本地图片完整路径
    var path: String {
        if png == nil {
            return ""
        }
        
        return Bundle.main.bundlePath + "/Emoticons.bundle/Contents/Resources/" + png!
    }
    /// 删除图片
    var deletePath: String {
        
        return Bundle.main.bundlePath + "/Emoticons.bundle/Contents/Resources/compose_emotion_delete"
    }
    /// 是否是删除按钮
    var isDelete: Bool = false
    /// 是否是空白
    var isEmpty: Bool = false
    /// emoji字符串
    var emoji: String?
    /// 使用次数
    var times: Int = 0
    
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
