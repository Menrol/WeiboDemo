//
//  EmoticonManager.swift
//  Emoticon
//
//  Created by Apple on 2017/8/11.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import Foundation

class EmoticonManager {
    
    /// 单例
    static let sharedManager = EmoticonManager()
    
    /// 表情包数组
    lazy var packages: [Package] = [Package]()
    /// 素材包
    lazy var bundle: Bundle = {
        let path = Bundle.main.path(forResource: "Emoticons.bundle", ofType: nil)
        
        return Bundle(path: path!)!
    }()
    
    // MARK: - 最近表情
    func addRecentEmoticon(emoticon: Emoticon) {
        // 判断是否是删除按钮
        if emoticon.isDelete {
            return
        }
        
        // 添加表情使用次数
        emoticon.times += 1
        
        // 判断表情是否被添加
        if !packages[0].emoticons.contains(emoticon) {
            // 添加最近表情
            packages[0].emoticons.insert(emoticon, at: 0)
            // 移除倒数第二个
            packages[0].emoticons.remove(at: packages[0].emoticons.count - 2)
        }
        
        // 排序
        packages[0].emoticons.sort { $0.times > $1.times}
    }
    
    // MARK: - 构造函数
    private init() {
        // 获取路径
        guard let path = Bundle.main.path(forResource: "Emoticons.bundle", ofType: nil),
            let bundle = Bundle(path: path),
            let plistPath = bundle.path(forResource: "emoticons.plist", ofType: nil),
            let array = NSArray(contentsOfFile: plistPath) as? [[String: String]]
            else {
                return
        }
        
        for dic in array {
            packages.append(Package(dictionary: dic))
        }
        
        print(packages)
    }
}
