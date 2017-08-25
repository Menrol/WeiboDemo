//
//  PictureBrowserViewCell.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/8/25.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit
import SDWebImage

class PictureBrowserViewCell: UICollectionViewCell {
    
    // 图片url
    var imageUrl: URL? {
        didSet{
            guard let url = imageUrl else {
                return
            }
            
            // 初始化ScrollView
            resetScrollView()
            
            imageView.image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: url.absoluteString)
            imageView.sizeToFit()
            imageView.center = scrollView.center
            
            imageView.sd_setImage(with: bmiddleUrl(url: url)) { (image, _, _, _) in
                self.setPosition(image: image!)
            }
        }
    }
    
    /// 初始化scrollView
    private func resetScrollView() {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentSize = CGSize.zero
    }
    
    /// bmiddleUrl
    private func bmiddleUrl(url: URL) -> URL {
        var urlString = url.absoluteString
        urlString = urlString.replacingOccurrences(of: "/thumbnail/", with: "/bmiddle/")
        return URL(string: urlString)!
    }
    
    /// 显示尺寸
    private func displaySize(image: UIImage) -> CGSize {
        let width = scrollView.bounds.width
        let height = image.size.height * width / image.size.width
        
        return CGSize(width: width, height: height)
    }
    
    /// 设置imageView位置
    private func setPosition(image: UIImage) {
        let size = displaySize(image: image)
        
        if size.height < scrollView.bounds.height {
            imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            // 设置内容边距
            let y = (scrollView.bounds.height - size.height) * 0.5
            scrollView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
        }else {
            imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            scrollView.contentSize = size
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
    fileprivate lazy var scrollView: UIScrollView = UIScrollView()
    fileprivate lazy var imageView: UIImageView = UIImageView()
}

// MARK: - UIScrollViewDelegate
extension PictureBrowserViewCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        var x = (scrollView.bounds.width - view!.frame.width) * 0.5
        x = x < 0 ? 0 : x
        var y = (scrollView.bounds.height - view!.frame.height) * 0.5
        y = y < 0 ? 0 : y
        scrollView.contentInset = UIEdgeInsetsMake(y, x, 0, 0)
    }
}

// MARK: - 设置界面
fileprivate extension PictureBrowserViewCell {
    func setupUI() {
        // 添加控件
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        // 设置布局
        var rect = bounds
        rect.size.width -= 20
        scrollView.frame = rect
        
        // 设置代理
        scrollView.delegate = self;
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2
    }
}
