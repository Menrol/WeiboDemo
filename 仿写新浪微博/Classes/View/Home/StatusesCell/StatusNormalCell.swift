//
//  StatusNormalCell.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/8/2.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class StatusNormalCell: StatusCell {

    override var viewModel: StatusViewModel? {
        didSet{
            pictureView.snp.updateConstraints { (make) in
                // 判断间距
                let offset = viewModel?.thumbnailUrls?.count ?? 0 > 0 ? StatusCellMargin : 0
                make.top.equalTo(contentLabel.snp.bottom).offset(offset)
            }
        }
    }
}

extension StatusNormalCell {
    override func setupUI() {
        super.setupUI()
        
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView.snp.left).offset(StatusCellMargin)
            make.width.equalTo(300)
            make.height.equalTo(400)
        }
    }
}
