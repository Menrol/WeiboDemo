//
//  StatusCellTopView.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/6/15.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class StatusCellTopView: UIView {
    
    /// 微博视图模型
    var viewModel: StatusViewModel? {
        didSet{
            // 更新约束
            layoutIfNeeded()
            
            // 微博头像
            iconImageView.rq_setImage(url: viewModel?.userIconURL, placeholderImage: viewModel?.userdefultImage, isAvatar: true)
            
            // 微博昵称
            nameLabel.text = viewModel?.status.user?.screen_name
            
            // 认证图标
            vipIconView.image = viewModel?.uservipImage
            
            // 会员图标
            memberIconView.image = viewModel?.userMemberImage
        }
    }

    
    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载控件
    /// 头像
    fileprivate lazy var iconImageView: UIImageView = UIImageView(imageName: "avatar_default_big")
    /// 认证图标
    fileprivate lazy var vipIconView: UIImageView = UIImageView(imageName: "avatar_vip")
    /// 用户昵称
    fileprivate lazy var nameLabel: UILabel = UILabel(text: "小李")
    /// 会员图标
    fileprivate lazy var memberIconView: UIImageView = UIImageView(imageName: "common_icon_membership_level1")
    /// 创建时间
    fileprivate lazy var timeLabel: UILabel = UILabel(text: "刚刚", font: 11)
    /// 来源
    fileprivate lazy var sourceLabel: UILabel = UILabel(text: "iPhone", font: 11)
}

// MARK: - 设置界面
extension StatusCellTopView {
    fileprivate func setupUI() {
        
        // 添加控件
        addSubview(iconImageView)
        addSubview(vipIconView)
        addSubview(nameLabel)
        addSubview(memberIconView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        
        // 设置位置
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(StatusCellMargin)
            make.left.equalTo(self.snp.left).offset(StatusCellMargin)
            make.width.equalTo(StatusCellIconWidth)
            make.height.equalTo(StatusCellIconWidth)
        }
        
        vipIconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconImageView.snp.right).offset(-4)
            make.centerY.equalTo(iconImageView.snp.bottom).offset(-4)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.top)
            make.left.equalTo(iconImageView.snp.right).offset(StatusCellMargin)
        }
        
        memberIconView.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.top)
            make.left.equalTo(nameLabel.snp.right).offset(StatusCellMargin)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconImageView.snp.bottom)
            make.left.equalTo(nameLabel.snp.left)
        }
        
        sourceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.top)
            make.left.equalTo(timeLabel.snp.right).offset(StatusCellMargin)
        }
    }
}


