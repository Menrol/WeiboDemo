//
//  UIButton+Extension.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/5/22.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

extension UIButton{
    
    /// 便利构造函数
    convenience init(imageName: String, backgroundImageName: String) {
        self.init()
        
        setImage(UIImage(named: imageName), for: UIControlState.normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: UIControlState.highlighted)
        setBackgroundImage(UIImage(named: backgroundImageName), for: UIControlState.normal)
        setBackgroundImage(UIImage(named: backgroundImageName + "_highlighted"), for: UIControlState.highlighted)
        sizeToFit()
    }
    
    /// 便利构造函数
    convenience init(title: String, backImageName: String, color: UIColor = UIColor.darkGray){
        self.init()
        
        setTitle(title, for: UIControlState.normal)
        setTitleColor(color, for: UIControlState.normal)
        setBackgroundImage(UIImage(named: backImageName), for: UIControlState.normal)
        
        sizeToFit()
    }
    
    /// 便利构造函数
    convenience init(title: String, imageName: String, fontSize: CGFloat, color: UIColor = UIColor.darkGray){
        self.init()
        
        setTitle(title, for: UIControlState.normal)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        setTitleColor(color, for: UIControlState.normal)
        setImage((UIImage(named: imageName)), for: UIControlState.normal)
        
        sizeToFit()
    }
}
