//
//  SQliteManager.swift
//  FMDBDemo
//
//  Created by Apple on 2017/9/4.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import Foundation
import FMDB

/// 数据库名称
private let name = "status.db"

class SQliteManager {
    static let sharedManager = SQliteManager()
    
    /// 全局操作队列
    let queue: FMDatabaseQueue
    
    private init() {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        path = (path as NSString).appendingPathComponent(name)
        
        print(path)
        
        /// 打开数据库队列
        queue = FMDatabaseQueue(path: path)
        
        createTable()
    }
    
    private func createTable() {
        let path = Bundle.main.path(forResource: "db.sql", ofType: nil)!
        let sql = try! String(contentsOfFile: path)
        
        queue.inDatabase { (db) in
            if db!.executeStatements(sql) {
                print("创表成功")
            }else {
                print("创表失败")
            }
        }
    }
    
    func execRecordSet(sql: String) -> [[String: Any]] {
        var result = [[String: Any]]()
        
        SQliteManager.sharedManager.queue.inDatabase { (db) in
            guard let rs = db?.executeQuery(sql, withParameterDictionary: nil) else {
                print("没有结果")
                
                return
            }
            
            while rs.next() {
                let cols = rs.columnCount()
                var dic = [String: Any]()
                
                for col in 0..<cols {
                    let name = rs.columnName(for: col)
                    let value = rs.object(forColumnIndex: col)
                    dic[name!] = value
                }
                
                result.append(dic)
            }
        }
        
        return result
    }
    
}
