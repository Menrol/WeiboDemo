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
                
                // 判断是否是动图
                iv.subviews[0].isHidden = (url.absoluteString as NSString).pathExtension != "gif"
                
                // 处理四张图片
                if index == 1 && viewModel?.thumbnailUrls?.count == 4 {
                    index += 2
                }else {
                    index += 1
                }
                
            }
            
            // 调整视图大小
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
    
    // MARK: - 监听方法
    @objc private func tapImageView(gesture: UITapGestureRecognizer) {
        let iv = gesture.view
        
        guard var selectedIndex = iv?.tag,
            let urls = viewModel?.thumbnailUrls else {
                return
        }
        
        // 处理四张图片
        if urls.count == 4 && selectedIndex > 1 {
            selectedIndex = selectedIndex - 1
        }
        
        var parentImageViews = [UIImageView]()
        for iv in subviews as! [UIImageView] {
            if !iv.isHidden {
                parentImageViews.append(iv)
            }
        }
        
        // 发送通知
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: WBStatusCellSelectedPcitureNotification), object: self, userInfo: [WBStatusCellPhotoBrowserSelectedIndexKey: selectedIndex, WBStatusCellPhotoBrowserUrlsKey: urls, WBStatusCellPhotoBrowserParentViewsKey: parentImageViews])
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
            
            // 设置tag
            imageView.tag = i
            
            // 添加gif提示
            addGIFTipView(imageView: imageView)
            
            // 添加手势
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapImageView(gesture:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGesture)
        }
    }
    
    /// 添加gif提示视图
    func addGIFTipView(imageView: UIImageView) {
        // 添加控件
        let iv = UIImageView()
        iv.image = UIImage(named: "timeline_image_gif")
        imageView.addSubview(iv)
        
        // 设置布局
        iv.snp.makeConstraints { (make) in
            make.right.equalTo(imageView.snp.right)
            make.bottom.equalTo(imageView.snp.bottom)
        }
    }
}

