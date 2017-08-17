//
//  String+Emoji.swift
//  Emoticon
//
//  Created by Apple on 2017/8/11.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import Foundation

extension String {
    
    var emoji: String {
        // 文本扫描器
        let scanner = Scanner(string: self)
        
        // Unicode的值
        var value: UInt32 = 0
        scanner.scanHexInt32(&value)
        
        // 转成Unicode字符
        let char = Character(UnicodeScalar(value)!)
        
        return "\(char)"
    }
}
