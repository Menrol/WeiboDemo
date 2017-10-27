//
//  StatusCell.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/6/15.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

/// 微博Cell中控件的间距
let StatusCellMargin: CGFloat = 12
/// 微博Cell配图视图间距
let StatusCellPictureViewMargin: CGFloat = 3
/// 微博Cell配图视图宽度
let StatusCellPictureViewItemWidth = (UIScreen.main.bounds.width - 2 * StatusCellMargin - 2 * StatusCellPictureViewMargin) / 3
/// 微博头像的宽度
let StatusCellIconWidth: CGFloat = 35

class StatusCell: UITableViewCell {
    
    /// 微博视图模型
    var viewModel: StatusViewModel? {
        didSet{
            topView.viewModel = viewModel
            
            let text = viewModel?.status.text ?? ""
            contentLabel.attributedText = EmoticonManager.sharedManager.emoticonText(text: text, font: contentLabel.font)
            
            pictureView.viewModel = viewModel
            
            pictureView.snp.updateConstraints { (make) in
                make.height.equalTo(viewModel?.pictureViewSize ?? CGSize())
            }
            
            bottomView.viewModel = viewModel
        }
    }

    // MARK: - 构造函数
    @objc override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setupUI()
        
        // 离屏渲染 - 异步绘制
        self.layer.drawsAsynchronously = true
        // 栅格化
        self.layer.shouldRasterize = true
        // 设定分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载控件
    /// 顶部试图
    fileprivate lazy var topView: StatusCellTopView = StatusCellTopView()
    /// 微博正文
    lazy var contentLabel: UILabel = UILabel(text: "", font: 15, textColor: UIColor.black, screenInset: StatusCellMargin)
    /// 配图
    lazy var pictureView: StatusCellPictureView = StatusCellPictureView()
    /// 底部视图
    lazy var bottomView: StatusCellBottomView = StatusCellBottomView()
}

// MARK: - 设置界面
extension StatusCell {
    @objc func setupUI() {
        // 背景颜色
        backgroundColor = UIColor.white
        
        /// 分割线视图
        let sepView = UIView()
        sepView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        // 添加控件
        contentView.addSubview(sepView)
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(bottomView)
        
        // 设置位置
        sepView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(StatusCellMargin)
        }
        
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(sepView.snp.bottom)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(StatusCellMargin + StatusCellIconWidth)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView.snp.left).offset(StatusCellMargin)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(pictureView.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(44)
        }
        
        // 设置微博文本
        contentLabel.layer.masksToBounds = true
        contentLabel.backgroundColor = UIColor.white
    }
}
