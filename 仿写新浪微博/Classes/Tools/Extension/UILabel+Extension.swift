//
//  UILabel+Extension.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/5/28.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

extension UILabel{
    
    convenience init(text: String?, font: CGFloat = 14, textColor: UIColor = UIColor.darkGray){
        self.init()
        
        self.text = text;
        self.font = UIFont.systemFont(ofSize: font)
        numberOfLines = 0
        self.textColor = textColor
        textAlignment = NSTextAlignment.center
    }
}
