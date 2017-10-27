//
//  StatusCellBottomView.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/6/15.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class StatusCellBottomView: UIView {
    
    var viewModel: StatusViewModel? {
        didSet {
            retweetButton.setTitle(viewModel?.reposts_count, for: .normal)
            commentButton.setTitle(viewModel?.comments_count, for: .normal)
            likeButton.setTitle(viewModel?.attitudes_count, for: .normal)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载控件
    /// 转发按钮
    fileprivate lazy var retweetButton: UIButton = UIButton(title: " 转发", imageName: "timeline_icon_retweet", fontSize: 12)
    /// 评论按钮
    fileprivate lazy var commentButton: UIButton = UIButton(title: " 评论", imageName: "timeline_icon_comment", fontSize: 12)
    /// 点赞按钮
    fileprivate lazy var likeButton: UIButton = UIButton(title: " 赞", imageName: "timeline_icon_unlike", fontSize: 12)
    
}

// MARK: - 设置界面
extension StatusCellBottomView {
    fileprivate func setupUI() {
        // 背景颜色
        backgroundColor = UIColor.white
        
        // 添加控件
        addSubview(retweetButton)
        addSubview(commentButton)
        addSubview(likeButton)
        
        // 设置位置
        retweetButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        commentButton.snp.makeConstraints { (make) in
            make.top.equalTo(retweetButton.snp.top)
            make.left.equalTo(retweetButton.snp.right)
            make.bottom.equalTo(retweetButton.snp.bottom)
            make.width.equalTo(retweetButton.snp.width)
        }
        
        likeButton.snp.makeConstraints { (make) in
            make.top.equalTo(commentButton.snp.top)
            make.left.equalTo(commentButton.snp.right)
            make.bottom.equalTo(commentButton.snp.bottom)
            make.width.equalTo(commentButton.snp.width)
            
            make.right.equalTo(self.snp.right)
        }
        
        // 分割视图
        let width = 0.6
        let scale = 0.4
        let seqView1 = sepView()
        let seqView2 = sepView()
        addSubview(seqView1)
        addSubview(seqView2)
        
        seqView1.snp.makeConstraints { (make) in
            make.centerX.equalTo(retweetButton.snp.right)
            make.centerY.equalTo(retweetButton.snp.centerY)
            make.width.equalTo(width)
            make.height.equalTo(retweetButton.snp.height).multipliedBy(scale)
        }
        
        seqView2.snp.makeConstraints { (make) in
            make.centerX.equalTo(commentButton.snp.right)
            make.centerY.equalTo(commentButton.snp.centerY)
            make.width.equalTo(width)
            make.height.equalTo(commentButton.snp.height).multipliedBy(scale)
        }
    }
    
    
    private func sepView() -> UIView {
        let sepView = UIView()
        sepView.backgroundColor = UIColor.darkGray
        
        return sepView
    }
}
