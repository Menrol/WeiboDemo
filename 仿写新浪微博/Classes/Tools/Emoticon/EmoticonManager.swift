//
//  EmoticonManager.swift
//  Emoticon
//
//  Created by Apple on 2017/8/11.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

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
    /// 最近表情路径
    var emoticonPath: String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        
        return (path as NSString).appendingPathComponent("recentEmoticons.plist")
    }
    
    // MARK: - 最近表情
    func addRecentEmoticon(emoticon: Emoticon) {
        // 判断是否是删除按钮
        if emoticon.isDelete {
            return
        }
        
        // 添加表情使用次数
        emoticon.times += 1
        
        var contain: Bool = false
        // 判断表情是否被添加
        for em in packages[0].emoticons {
            if em.chs == emoticon.chs && em.chs != nil{
                em.times += 1
                contain = true
            }else if em.code == emoticon.code && em.code != nil {
                em.times += 1
                contain = true
            }
        }
        if !contain {
            // 添加最近表情
            packages[0].emoticons.insert(emoticon, at: 0)
            // 移除倒数第二个
            packages[0].emoticons.remove(at: packages[0].emoticons.count - 2)
        }
        
        // 排序
        packages[0].emoticons.sort {$0.times > $1.times}
        
        // 保存在本地
        NSKeyedArchiver.archiveRootObject(packages[0].emoticons, toFile: emoticonPath)
    }
    
    // MARK: - 生成属性字符串
    /// 将字符串转成带表情的属性字符串
    func emoticonText(text: String, font: UIFont) -> NSAttributedString? {
        // 生成属性字符串
        let atr = NSMutableAttributedString(string: text)
        
        // 匹配字符串
        let pattern = "\\[.*?\\]"
        let regularEx = try! NSRegularExpression(pattern: pattern, options: [])
        let result = regularEx.matches(in: text, options: [], range: NSRange(location: 0, length: text.characters.count))
        
        // 遍历
        var count = result.count - 1
        while count >= 0 {
            // 获取range
            let range = result[count].range(at: 0)
            count = count - 1
            
            // 获取表情
            let emString = (text as NSString).substring(with: range)
            guard let emoticon = emoticonWithString(string: emString) else {
                continue
            }
            
            // 获取表情属性文本
            let imageText = EmoticonAttachment(emoticon: emoticon).imageText(font: font)
            atr.replaceCharacters(in: range, with: imageText)
        }
        
         atr.addAttributes([NSAttributedStringKey.font: font], range: NSRange(location: 0, length: atr.length))
        
        return atr
    }
    
    /// 根据表情字符串获取表情模型
    private func emoticonWithString(string: String) -> Emoticon? {
        // 遍历表情包
        for package in EmoticonManager.sharedManager.packages {
            
            if let emoticon = package.emoticons.filter({ $0.chs == string }).last {
                return emoticon
            }
        }
        
        return nil
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
        
        print(packages[0].emoticons[20].isDelete)
        
        // 获取最近表情
        if let recentEmoticons = NSKeyedUnarchiver.unarchiveObject(withFile: emoticonPath) as? [Emoticon] {
            packages[0].emoticons = recentEmoticons
        }
        
    }
}
