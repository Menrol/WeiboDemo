//
//  UILabel+Extension.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/5/28.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

extension UILabel{
    
    /// 便利构造函数
    convenience init(text: String?, font: CGFloat = 14, textColor: UIColor = UIColor.darkGray,screenInset: CGFloat = 0){
        self.init()
        
        self.text = text;
        self.font = UIFont.systemFont(ofSize: font)
        numberOfLines = 0
        self.textColor = textColor
        if screenInset == 0 {
            textAlignment = NSTextAlignment.center
        }else{
            preferredMaxLayoutWidth = UIScreen.main.bounds.width - 2 * screenInset
            textAlignment = .left
        }
    }
}
