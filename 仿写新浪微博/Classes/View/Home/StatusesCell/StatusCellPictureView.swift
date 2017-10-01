//
//  StatusCellPictureView.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/7/29.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit
import SDWebImage

/// 图片之间的间距
fileprivate let StatusCellPictureViewItemMargin: CGFloat = UIScreen.main.scale * 4
/// 自定义cellid
fileprivate let PictureViewCellId = "PictureViewCellId"
/// 选择照片通知
let WBStatusSelectedPcitureNotification = "WBStatusSelectedPcitureNotification"
/// 选中照片索引key
let WBStatusSelectedPictureIndexPathKey = "WBStatusSelectedPictureIndexKey"
/// 照片数组key
let WBStatusSelectedPictureUrlsKey = "WBStatusSelectedPictureUrlsKey"

class StatusCellPictureView: UICollectionView {
    
    /// 微博数据模型
    var viewModel: StatusViewModel?{
        didSet{
            // 计算大小
            sizeToFit()
            
            // 刷新数据
            reloadData()
            
            // 设置颜色
            if viewModel?.status.retweeted_status != nil {
                backgroundColor = UIColor(white: 0.95, alpha: 1)
            }else {
                backgroundColor = UIColor.white
            }
        }
    }

    // MARK: - 构造函数
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = StatusCellPictureViewItemMargin
        layout.minimumInteritemSpacing = StatusCellPictureViewItemMargin
        
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        
        dataSource = self
        delegate = self
        register(PictureViewCell.self, forCellWithReuseIdentifier: PictureViewCellId)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDataSource
extension StatusCellPictureView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.thumbnailUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: PictureViewCellId, for: indexPath) as! PictureViewCell
        cell.imageURL = viewModel?.thumbnailUrls![indexPath.row]
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension StatusCellPictureView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: WBStatusSelectedPcitureNotification), object: self, userInfo: [WBStatusSelectedPictureIndexPathKey: indexPath, WBStatusSelectedPictureUrlsKey: viewModel!.thumbnailUrls!])
    }
}

// MARK: - PictureBrowserPresentDelegate
extension StatusCellPictureView: PictureBrowserPresentDelegate {
    func imageViewForAnimation(indexPath: IndexPath) -> UIImageView {
        let imageView = UIImageView()
        
        // 设置填充模式
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        guard let url = viewModel?.thumbnailUrls?[indexPath.item] else {
            return imageView
        }
        
        imageView.sd_setImage(with: url)
        
        return imageView
    }
    
    func startPositionForAnimation(indexPath: IndexPath) -> CGRect {
        let cell = cellForItem(at: indexPath)!
        let rect = self.convert(cell.frame, to: UIApplication.shared.keyWindow)
        
//        // 测试代码
//        let iv = imageViewForAnimation(indexPath: indexPath)
//        iv.frame = rect
//        UIApplication.shared.keyWindow?.addSubview(iv)
        
        return rect
    }
    
    func endPositionForAnimation(indexPath: IndexPath) -> CGRect {
        guard let key = viewModel?.thumbnailUrls?[indexPath.item].absoluteString else {
            return CGRect.zero
        }
        
        guard let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: key) else {
            return CGRect.zero
        }
        
        let w = UIScreen.main.bounds.width
        let h = image.size.height * w / image.size.width
        
        let y: CGFloat
        if h > UIScreen.main.bounds.height {
            y = 0
        }else {
            y = (UIScreen.main.bounds.height - h) * 0.5
        }
        
        let rect = CGRect(x: 0, y: y, width: w, height: h)
        
//        // 测试代码
//        let iv = imageViewForAnimation(indexPath: indexPath)
//        iv.frame = rect
//        UIApplication.shared.keyWindow?.addSubview(iv)
        
        return rect
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
