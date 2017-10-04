//
//  Bundle+Extension.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/10/4.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import Foundation

extension Bundle {
    /// 命名空间
    var namespace: String {
       
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}
