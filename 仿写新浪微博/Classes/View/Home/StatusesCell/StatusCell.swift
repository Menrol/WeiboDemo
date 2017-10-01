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
/// 微博头像的宽度
let StatusCellIconWidth: CGFloat = 35

class StatusCell: UITableViewCell {
    
    /// 微博视图模型
    var viewModel: StatusViewModel? {
        didSet{
            topView.viewModel = viewModel
            contentLabel.text = viewModel?.status.text
            pictureView.viewModel = viewModel
            
            pictureView.snp.updateConstraints { (make) in
                make.width.equalTo(pictureView.bounds.width)
                make.height.equalTo(pictureView.bounds.height)
            }
            
            bottomView.viewModel = viewModel
        }
    }
    
    func rowHeight(viewModel: StatusViewModel) -> CGFloat{
        // 设置模型
        self.viewModel = viewModel
        
        // 更新约束
        contentView.layoutIfNeeded()
        
        return CGRect(origin: bottomView.frame.origin, size: bottomView.frame.size).maxY
        
    }

    // MARK: - 构造函数
    @objc override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setupUI()
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
    }
}
