//
//  UIImageView+Extension.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/5/28.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

extension UIImageView{
    
    convenience init(imageName: String){
        self.init(image: UIImage(named: imageName))
    }
}
