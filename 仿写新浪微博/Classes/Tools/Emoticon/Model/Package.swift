//
//  Package.swift
//  Emoticon
//
//  Created by Apple on 2017/8/11.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class Package: NSObject {
    /// 分组名称
    var group_name_cn: String?
    /// 路径
    var id: String?
    /// 表情数组
    lazy var emoticons:[Emoticon] = [Emoticon]()
    
    // MARK: - 构造函数
    init(dictionary:[String: Any]) {
        super.init()
        
        id = dictionary["id"] as? String
        group_name_cn = dictionary["group_name_cn"] as? String
        
        var count = 0
        if let array = dictionary["emoticons"] as? [[String: Any]] {
            for var dic in array {
                if let png = dic["png"] as? String, let p = id {
                    dic["png"] = p + "/" + png
                }
                emoticons.append(Emoticon(dictionary: dic))
                count += 1
                if count == 20 {
                    emoticons.append(Emoticon(isDelete: true))
                    count = 0
                }
            }
        }
        addEmptyEmoticon()
    }
    
    private func addEmptyEmoticon() {
        let moreCount = emoticons.count % 21
        if emoticons.count > 0 && moreCount == 0{
            return
        }
        
        for _ in moreCount..<20 {
            emoticons.append(Emoticon(isEmpty: true))
        }
        emoticons.append(Emoticon(isDelete: true))
    }
    
    override var description: String {
        let keys = ["group_name_cn","id","emoticons"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
    
}
