//
//  StatusListViewModel.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/6/14.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import Foundation
import SDWebImage

/// 微博数据模型 - 封装网络方法
class StatusListViewModel {
    /// 数据模型
    lazy var statusList: [StatusViewModel] = [StatusViewModel]()
    /// 下拉刷新个数
    var pullDownCount: Int?
}

// MARK: - 网络处理
extension StatusListViewModel {
    func loadData(ispullUp: Bool, finished: @escaping (_ isSuccess: Bool) -> Void){
        let since_id = ispullUp ? 0 : (statusList.first?.status.id ?? 0)
        let max_id = ispullUp ? (statusList.last?.status.id ?? 0) : 0
        
        StatusDAL.loadData(since_id: since_id, max_id: max_id) { (array) in
            guard let array = array else {
                finished(false)
                
                return
            }
            
            var dataList = [StatusViewModel]()
            
            for dic in array{
                dataList.append(StatusViewModel(status:Status(dic:dic)))
            }
            
            // 设置下拉刷新个数
            self.pullDownCount = since_id > 0 ? dataList.count : nil
            
            // 拼接数组
            if max_id > 0 {
                self.statusList += dataList
            }else {
                self.statusList = dataList + self.statusList
            }
            
//            print("刷新了\(dataList.count)个微博")
            
            // 缓存单张图片
            self.cacheSingleImage(dataList: dataList, finished: finished)
        }
    }
    
    /// 缓存单张图片
    private func cacheSingleImage(dataList: [StatusViewModel],finished: @escaping (_ isSuccess: Bool) -> Void){
        let dispatchGroup = DispatchGroup()
        var dataLength = 0
        
        for viewModel in dataList {
            if viewModel.thumbnailUrls?.count != 1 {
                continue
            }
            
            let url = viewModel.thumbnailUrls![0]
            
            // 入组
            dispatchGroup.enter()
            
            print(url)
            
            // SDWebImage核心下载图片函数
            SDWebImageManager.shared().loadImage(with:url,options: [],progress: nil,completed: { (image, _, _, _, _, url) in
                
                if let img = image,let data = UIImagePNGRepresentation(img) {
                    dataLength += data.count
                }
                
                // 出组
                dispatchGroup.leave()
            })
        }
        
        // 组内任务完成
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            print("缓存完成 \(dataLength / 1024)k")
            finished(true)
        })
    }
}
