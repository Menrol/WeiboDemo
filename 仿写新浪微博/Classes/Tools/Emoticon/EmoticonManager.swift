//
//  EmoticonManager.swift
//  Emoticon
//
//  Created by Apple on 2017/8/11.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import Foundation

class EmoticonManage {
    
    /// 单例
    static let sharedManager = EmoticonManage()
    
    /// 表情包数组
    lazy var packages: [Package] = [Package]()
    
    /// 构造函数
    private init() {
        // 获取路径
        let path = Bundle.main.path(forResource: "emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        // 获取表情包字典
        let dic = NSDictionary(contentsOfFile: path) as! [String: Any]
        // 获取id数组
        let array = (dic["packages"] as! NSArray).value(forKey: "id")
        
        packages.append(Package(dictionary: ["group_name_cn": "最近"]))
        
        for id in array as! [String] {
            loadInfoPlist(id: id)
        }
    }
    
    /// 加载每个表情包的info.plist
    private func loadInfoPlist(id: String) {
        let path = Bundle.main.path(forResource: "info.plist", ofType: nil, inDirectory: "Emoticons.bundle/\(id)")!
        let dic = NSDictionary(contentsOfFile: path) as! [String: Any]
        packages.append(Package(dictionary: dic))
    }
}
