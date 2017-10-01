//
//  UIColor+Extension.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/8/25.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

extension UIColor {
    class func randomColor() -> UIColor {
        let r = CGFloat(arc4random() % 256) / 255
        let b = CGFloat(arc4random() % 256) / 255
        let g = CGFloat(arc4random() % 256) / 255
        
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}
