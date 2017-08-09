//
//  StatusCellPictureView.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/7/29.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit
import SDWebImage

// 图片之间的间距
fileprivate let StatusCellPictureViewItemMargin: CGFloat = 8
// 自定义cellid
fileprivate let PictureViewCellId = "PictureViewCellId"

class StatusCellPictureView: UICollectionView {
    
    /// 微博数据模型
    var viewModel: StatusViewModel?{
        didSet{
            // 计算大小
            sizeToFit()
            
            // 刷新数据
            reloadData()
        }
    }

    // MARK: - 构造函数
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = StatusCellPictureViewItemMargin
        layout.minimumInteritemSpacing = StatusCellPictureViewItemMargin
        
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        
        backgroundColor = UIColor.white
        dataSource = self
        register(PictureViewCell.self, forCellWithReuseIdentifier: PictureViewCellId)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDataSource
extension StatusCellPictureView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.thumbnailUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: PictureViewCellId, for: indexPath) as! PictureViewCell
        cell.imageURL = viewModel?.thumbnailUrls![indexPath.row]
        
        return cell
    }
}

// MARK: - 计算尺寸
extension StatusCellPictureView {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        // 图片个数
        let rowCount: CGFloat = 3
        // 最大宽度
        let maxWidth = UIScreen.main.bounds.width - 2 * StatusCellMargin
        // 图片尺寸
        let itemWidth = (maxWidth - 2 * StatusCellPictureViewItemMargin) / rowCount
        // 图片个数
        let count = viewModel?.thumbnailUrls?.count ?? 0
        
        // 设置layout的itemSize
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        if count == 0 {
            return CGSize.zero
        }
        
        if count == 1 {
            var size = CGSize(width: 150, height: 120)
            
            if let url = viewModel?.thumbnailUrls?.first?.absoluteString {
                let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: url)
                if let s = image?.size {
                    size = s
                }
            }
            
            // 过窄处理
            size.width = size.width < 40 ? 40 : size.width
            
            // 过宽处理
            if size.width > 300 {
                let w:CGFloat = 300
                let h = size.height * w / size.width
                size = CGSize(width: w, height: h)
            }
            
            layout.itemSize = size
            
            return size
        }
        
        if count == 4 {
            let width = itemWidth * 2 + StatusCellPictureViewItemMargin
            let height = 2 * itemWidth + StatusCellPictureViewItemMargin
        
            return CGSize(width: width, height: height)
        }
        
        let row = CGFloat((count - 1) / Int(rowCount) + 1)
        let height = row * itemWidth + (row - 1) * StatusCellPictureViewItemMargin
        let width = rowCount * itemWidth + (rowCount - 1) * StatusCellPictureViewItemMargin
        
        return CGSize(width: width, height: height)
    }
    
}

// MARK: - 自定义Cell
class PictureViewCell: UICollectionViewCell {
    
    var imageURL:URL?{
        didSet{
            iconImageView .sd_setImage(with: imageURL, placeholderImage: nil, options: [.refreshCached,.retryFailed])
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
    fileprivate lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    // MARK: - 设置界面
    private func setupUI(){
        
        // 添加控件
        contentView.addSubview(iconImageView)
        
        // 设置位置
        iconImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView.snp.edges)
        }
    }
}
