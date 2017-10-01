//
//  UIImage+Extension.swift
//  照片选择
//
//  Created by Apple on 2017/8/24.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

extension UIImage {
    func scaleToWidth(width: CGFloat) -> UIImage {
        if size.width < width {
            return self
        }
        
        let height = size.height * width / size.width
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        
        // 开启上下文
        UIGraphicsBeginImageContext(rect.size)
        // 绘制图
        self.draw(in: rect)
        // 取结果
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        // 关闭上下文
        UIGraphicsEndImageContext()
        
        return image
    }
}
