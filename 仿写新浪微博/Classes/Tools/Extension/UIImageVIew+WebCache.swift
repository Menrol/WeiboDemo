//
//  UIImageVIew+WebCache.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/9/26.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import SDWebImage

extension UIImageView {
    
    func rq_setImage(url: URL?, placeholderImage: UIImage?, isAvatar: Bool = false) {
        
        sd_setImage(with: url, placeholderImage: placeholderImage, options: [], progress: nil) { (image, _, _, _) in
            if isAvatar {
                self.image = image?.rq_avatarImage(size: self.bounds.size, backColor: UIColor.white)
            }
            
            if image == nil {
                self.isHidden = true
            }
        }
    }
}
