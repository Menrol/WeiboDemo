//
//  Emoticon.swift
//  Emoticon
//
//  Created by Apple on 2017/8/11.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class Emoticon: NSObject,NSCoding {
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
    @objc var isDelete: Bool = false
    /// 是否是空白
    @objc var isEmpty: Bool = false
    /// emoji字符串
    @objc var emoji: String?
    /// 使用次数
    @objc var times: Int = 0
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(chs, forKey: "chs")
        aCoder.encode(png, forKey: "png")
        aCoder.encode(code, forKey: "code")
        aCoder.encode(isDelete, forKey: "isDelete")
        aCoder.encode(isEmpty, forKey: "isEmpty")
        aCoder.encode(emoji, forKey: "emoji")
        aCoder.encode(times, forKey: "times")
    }
    
    required init?(coder aDecoder: NSCoder) {
        chs = aDecoder.decodeObject(forKey: "chs") as? String
        png = aDecoder.decodeObject(forKey: "png") as? String
        code = aDecoder.decodeObject(forKey: "code") as? String
        isDelete = aDecoder.decodeBool(forKey: "isDelete")
        isEmpty = aDecoder.decodeBool(forKey: "isEmpty")
        emoji = aDecoder.decodeObject(forKey: "emoji") as? String 
        times = Int(aDecoder.decodeInt64(forKey: "times"))
    }
    
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
