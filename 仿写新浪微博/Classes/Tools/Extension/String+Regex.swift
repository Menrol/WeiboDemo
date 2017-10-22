//
//  String+Regex.swift
//  text
//
//  Created by Apple on 2017/10/22.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import Foundation

extension String {
    
    func getSource() -> (link: String, text: String)? {
        // 匹配方案
        let pattern = "<a href=\"(.*?)\" rel=\"nofollow\">(.*?)</a>"
        // 创建正则表达式
        let regularEx = try! NSRegularExpression(pattern: pattern, options: [])
        
        guard let result = regularEx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.characters.count)) else {
            print("没有匹配到")
            
            return nil
        }
        
        let linkRange = result.range(at: 1)
        let link = (self as NSString).substring(with: linkRange)
        let textRange = result.range(at: 2)
        let text = (self as NSString).substring(with: textRange)
        
        return (link,text)
    }
}
