//
//  NSDate+Extension.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/10/21.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import Foundation

extension Date {
    
    /// 新浪微博日期
    static func sinaDate(string: String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        df.locale = Locale(identifier: "en")
        
        return df.date(from: string)
    }
    
    /**
     * 返回当前日期的描述信息
     
     * 刚刚(一分钟内）
     * x分钟前(一小时内)
     * x小时前(当天)
     * 昨天 HH:mm(昨天)
     * MM-dd HH:mm(一年内)
     * yyyy-MM-dd HH:mm(更早期)
     */
    var dateDescirption: String {
        let calender = Calendar.current
        
        if calender.isDateInToday(self) {
            let time = Int(Date().timeIntervalSince(self))

            if time < 60 {
                return "刚刚"
            }
            
            if time < 3600 {
                return "\(time / 60)分钟前"
            }
            
            return "\(time / 3600)小时前"
        }
        
        var fmt = " HH:mm"
        if calender.isDateInYesterday(self) {
            fmt = "昨天" + fmt
        }else {
            fmt = "MM-dd" + fmt
            
            // 判断两个日期的年度插值
            let component = calender.dateComponents([.year], from: self, to: Date())
            
            if component.year ?? 0 > 0 {
                fmt = "yyyy-" + fmt
            }
        }
        
        // 创建时间格式
        let df = DateFormatter()
        df.locale = Locale(identifier: "en")
        df.dateFormat = fmt
        
        return df.string(from: self)
    }
    
    
}
