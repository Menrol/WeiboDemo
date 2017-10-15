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
    @objc var groupName: String?
    /// 路径
    @objc var directory: String? {
        didSet {
            // 获取路径
            guard let diretory = directory,
                let path = Bundle.main.path(forResource: "Emoticons.bundle", ofType: nil),
                let bundle = Bundle(path: path),
                let plistPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: diretory)
                else {
                    return
            }
            
            var count = 0
            if let array = NSArray(contentsOfFile: plistPath) as? [[String: Any]] {
                for var dic in array {
                    if let png = dic["png"] as? String, let p = directory {
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
        }
    }
    /// 背景图片
    @objc var bgImageName: String?
    /// 表情数组
    @objc lazy var emoticons:[Emoticon] = [Emoticon]()
    /// 表情页数
    var numberOfPages: Int {
        return (emoticons.count - 1) / 21 + 1
    }
    
    /// 每页的表情数组
    func emoticons(page: Int) -> [Emoticon] {
        var length = 21
        let location = page * length
        if location + length > emoticons.count - 1 {
            length = emoticons.count - location
        }
        let array = (emoticons as NSArray).subarray(with: NSRange(location: location, length: length))
        
        return array as! [Emoticon]
    }
    
    // MARK: - 构造函数
    init(dictionary:[String: String]) {
        super.init()
        
        setValuesForKeys(dictionary)
        
        // 添加空表情
        addEmptyEmoticon()
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
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
        let keys = ["groupName", "directory", "bgImageName", "emoticons"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
    
}
