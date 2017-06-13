//
//  Common.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/6/10.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

/// 通知名称
let WBSwitchRootViewControllerNotification = "WBSwitchRootViewControllerNotification"

/// 延时函数
func delay(time: Double,execute:@escaping () -> Void){
    DispatchQueue.main.asyncAfter(deadline: .now() + time) { 
        execute()
    }
}
