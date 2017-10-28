//
//  StatusRetweetCell.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/8/2.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class StatusRetweetCell: StatusCell {
    
    override var viewModel: StatusViewModel?{
        didSet{
//            let text = viewModel?.retweetText ?? ""
//            retweetLabel.attributedText = EmoticonManager.sharedManager.emoticonText(text: text, font: retweetLabel.font)
            retweetLabel.text = viewModel?.retweetText
            
            pictureView.snp.updateConstraints { (make) in
                // 判断间距
                let offset = viewModel?.thumbnailUrls?.count ?? 0 > 0 ? StatusCellMargin : 0
                make.top.equalTo(retweetLabel.snp.bottom).offset(offset)
            }
        }
    }
    
    // MARK: - 懒加载控件
    /// 背景视图
    fileprivate lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        return button
    }()
    /// 转发文字
    fileprivate lazy var retweetLabel: UILabel = UILabel(text: "转发转发转发转发转发转发转发转发转发转发转发转发转发转发", font: 14, screenInset: StatusCellMargin)

}

// MARK: - 设置界面
extension StatusRetweetCell {
    override func setupUI() {
        super.setupUI()
                
        // 添加控件
        contentView.insertSubview(backButton, belowSubview: pictureView)
        contentView.insertSubview(retweetLabel, aboveSubview: backButton)
        
        // 设置位置
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        retweetLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backButton.snp.top).offset(StatusCellMargin)
            make.left.equalTo(backButton.snp.left).offset(StatusCellMargin)
        }
        
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(retweetLabel.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView.snp.left).offset(StatusCellMargin)
            make.right.equalTo(contentView.snp.right).offset(-StatusCellMargin)
            make.height.equalTo(400)
        }
        
        // 设置转发微博文本
        retweetLabel.layer.masksToBounds = true
        retweetLabel.backgroundColor = UIColor(white: 0.95, alpha: 1)

    }
}
