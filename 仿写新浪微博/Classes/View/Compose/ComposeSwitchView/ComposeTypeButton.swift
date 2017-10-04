//
//  ComposeTypeButton.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/10/2.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class ComposeTypeButton: UIControl {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    /// 控制器名称
    var className: String?
    
    class func button(imageName: String, title: String) -> ComposeTypeButton {
        let nib = UINib(nibName: "ComposeTypeButton", bundle: nil)
        let button = nib.instantiate(withOwner: nil, options: nil)[0] as! ComposeTypeButton
        
        button.imageView.image = UIImage(named: imageName)
        button.titleLabel.text = title
        
        return button
    }

}
