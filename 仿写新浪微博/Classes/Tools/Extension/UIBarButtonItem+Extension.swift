//
//  UIBarButtonItem+Extension.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/8/16.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /// 便利构造函数
    convenience init(imageName: String, target: Any?, actionName: String?) {
        let button = UIButton(imageName: imageName, backgroundImageName: nil)
        if let actionName = actionName{
            button.addTarget(target, action: Selector(actionName), for: .touchUpInside)
        }
        
        self.init(customView: button)
    }
}
