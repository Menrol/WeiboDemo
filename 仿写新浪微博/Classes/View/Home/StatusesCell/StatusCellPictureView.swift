//
//  StatusCellPictureView.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/10/24.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class StatusCellPictureView: UIView {
    
    var viewModel: StatusViewModel? {
        didSet {
            // 隐藏所有imageView
            for v in subviews {
                v.isHidden = true
            }

            var index = 0
            for url in viewModel?.thumbnailUrls ?? [] {
                let iv = subviews[index] as! UIImageView
                iv.isHidden = false
                iv.rq_setImage(url: url, placeholderImage: nil)
                
                // 处理四张图片
                if index == 1 && viewModel?.thumbnailUrls?.count == 4 {
                    index += 2
                }else {
                    index += 1
                }
            }
            
            calViewSize()
        }
    }
    
    /// 调整配图大小
    private func calViewSize() {
        // 单图
        if viewModel?.thumbnailUrls?.count == 1 {
            let size = viewModel?.pictureViewSize ?? CGSize()
            
            let v = subviews[0]
            v.frame.size = size
        }else {
            // 多图
            let v = subviews[0]
            v.frame.size = CGSize(width: StatusCellPictureViewItemWidth,
                                  height: StatusCellPictureViewItemWidth)
        }
    }

    // MARK: - 构造函数
    init() {
        super.init(frame: CGRect())
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 设置界面
private extension StatusCellPictureView {
    func setupUI() {
        clipsToBounds = true
        backgroundColor = superview?.backgroundColor
        
        let count = 3
        
        for i in 0..<count * count {
            let imageView = UIImageView()
            // 设置图片模式
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            
            addSubview(imageView)
            
            imageView.frame = CGRect(x: 0, y: 0, width: StatusCellPictureViewItemWidth, height: StatusCellPictureViewItemWidth)
            
            // 设置偏移
            let row = i / count
            let col = i % count
            let offsetX = CGFloat(col) * StatusCellPictureViewMargin + CGFloat(col) * StatusCellPictureViewItemWidth
            let offsetY = CGFloat(row) * StatusCellPictureViewMargin + CGFloat(row) * StatusCellPictureViewItemWidth
            
            imageView.frame = imageView.frame.offsetBy(dx: offsetX, dy: offsetY)
            
        }
    }
}

