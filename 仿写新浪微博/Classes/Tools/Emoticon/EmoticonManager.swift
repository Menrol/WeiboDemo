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
    
    /// 构造函数
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
