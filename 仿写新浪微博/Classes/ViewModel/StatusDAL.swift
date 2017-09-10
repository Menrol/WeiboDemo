//
//  StatusDAL.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/9/5.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import Foundation

/// 最大缓存时间
private let maxCacheTime: TimeInterval = 7 * 24 * 60 * 60

class StatusDAL {
    class func loadData(since_id: Int, max_id: Int, finished: @escaping (_ array: [[String: Any]]?) -> Void) {
        // 检查是否有缓存数据
        let data = checkCacheData(since_id: since_id, max_id: max_id)
        
        // 如果有,返回缓存数据
        if data?.count ?? 0 > 0 {
            finished(data!)
            print("从本地取到数据 \(data!.count)")
            
            return
        }
        
        // 如果没有,加载数据
        NetworkTool.sharedTool.loadStatuses(since_id: since_id,max_id: max_id) { (result, error) in
            
            if error != nil{
                print("出错了")
                finished(nil)
                
                return
            }
            
            guard let array = (result as AnyObject)["statuses"]  as? [[String: Any]] else{
                print("数据格式错误")
                finished(nil)
                
                return
            }
            
            // 将数据保存到数据库中
            StatusDAL.saveCacheData(array: array)
            // 将网络数据返回给调用方
            finished(array)
        }
    }
    
    class func cleanCache() {
        let date = Date(timeIntervalSinceNow: -maxCacheTime)
        
        // 日期格式转换
        let dateFormatter = DateFormatter()
        // 指定区域
        dateFormatter.locale = Locale(identifier: "en")
        // 日期格式
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // 日期字符串
        let dateStr = dateFormatter.string(from: date)
        
        // 执行sql
        let sql = "DELETE FROM T_Status WHERE createTime < ?;"
        SQliteManager.sharedManager.queue.inDatabase { (db) in
            if db!.executeUpdate(sql, withArgumentsIn: [dateStr]) {
                print("删除了\(db!.changes())条数据")
            }
        }
    }
    
    private class func checkCacheData(since_id: Int, max_id: Int) -> [[String: Any]]? {
        // userId
        guard let userId = UserAccountViewModel.sharedUersAccount.userAccount?.uid else {
            print("用户未登录")
            
            return nil
        }
        
        // 准备sql
        var sql = "SELECT statusId, status, userId FROM T_Status \n"
        sql += "WHERE userId = \(userId) \n"
        if since_id > 0 {
            sql += "AND statusId > \(since_id) \n"
        }else if max_id > 0 {
            sql += "AND statusId < \(max_id) \n"
        }
        sql += "ORDER BY statusId DESC LIMIT 20;"
        
        print(sql)
        
        // 执行sql
        let array = SQliteManager.sharedManager.execRecordSet(sql: sql)
        
        var result = [[String: Any]]()
        for dic in array {
            let data = dic["status"] as! Data
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            
            result.append(json as! [String : Any])
        }
        
        return result
    }
    
    private class func saveCacheData(array: [[String: Any]]) {
        // 用户Id
        guard let userId = UserAccountViewModel.sharedUersAccount.userAccount?.uid else {
            print("用户未登录")
            
            return
        }
        
        // sql语句
        let sql = "INSERT OR REPLACE INTO T_Status (statusId,status,userId) VALUES (?,?,?);"
        
        SQliteManager.sharedManager.queue.inTransaction({ (db, rollback) in
            for dic in array {
                // 微博Id
                let  statusId = dic["id"] as! Int
                // 微博
                let status = try! JSONSerialization.data(withJSONObject: dic, options: [])
                
                if !db!.executeUpdate(sql, withArgumentsIn: [statusId,status,userId]){
                    // 回滚
                    rollback?.pointee = true
                }
            }
        })
    }
}
