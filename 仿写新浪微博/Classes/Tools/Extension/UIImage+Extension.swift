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
        draw(in: rect)
        // 取结果
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        // 关闭上下文
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func rq_avatarImage(size: CGSize?, backColor: UIColor?, lineColor: UIColor = UIColor.lightGray) -> UIImage? {
        var size = size
        if size == nil {
            size = self.size
        }
        
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        // 开启上下文
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        // 背景填充
        backColor?.setFill()
        UIRectFill(rect)
        
        // 获得圆形路径
        let path = UIBezierPath(ovalIn: rect)
        // 进行路径裁切
        path.addClip()
        
        // 绘图
        draw(in: rect)
        
        // 绘制边线
        UIColor.lightGray.setStroke()
        path.stroke()
        
        // 获取图片
        let result = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        
        return result
    }
}
