//
//  PictureBrowserViewCell.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/8/25.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit
import SDWebImage

protocol PictureBrowserCellDelegate: NSObjectProtocol {
    func pictureBrowserViewCellDidTapImage()
}

class PictureBrowserViewCell: UICollectionViewCell {
    
    // MARK: - 监听方法
    @objc fileprivate func tapPicture() {
        pictureDelegate?.pictureBrowserViewCellDidTapImage()
    }
    
    /// 代理
    weak var pictureDelegate: PictureBrowserCellDelegate?
    
    /// MARK: - 设置图片
    var imageUrl: URL? {
        didSet{
            guard let url = imageUrl else {
                return
            }
            
            // 初始化ScrollView
            resetScrollView()
            
            let placeholderImage = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: url.absoluteString)
            preparePlaceHolder(image: placeholderImage)
            
            imageView.sd_setImage(with: bmiddleUrl(url: url), placeholderImage: placeholderImage, options: [.refreshCached,.retryFailed], progress: { (current, total, _) in
                DispatchQueue.main.async(execute: { 
                    self.placeholder.progress = CGFloat(current) / CGFloat(total)
                })
            }) { (image, _, _, _) in
                // 隐藏占位视图
                self.placeholder.isHidden = true
                // 设置图片位置
                self.setPosition(image: image!)
            }
        }
    }
    
    /// 准备占位视图
    private func preparePlaceHolder(image: UIImage?) {
        placeholder.image = image
        
        guard let image = image else {
            return
        }
        
        let w = UIScreen.main.bounds.width
        let h = image.size.height * w / image.size.width
        let rect = CGRect(x: 0, y: 0, width: w, height: h)
        
        placeholder.bounds = rect
        placeholder.center = scrollView.center
    }
    
    /// 初始化scrollView
    private func resetScrollView() {
        // 重新设置imageView的属性
        imageView.transform = CGAffineTransform.identity
        
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
    lazy var imageView: FLAnimatedImageView = FLAnimatedImageView()
    fileprivate lazy var placeholder: ProgressImageView = ProgressImageView()
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
        scrollView.addSubview(placeholder)
        
        // 设置布局
        var rect = bounds
        rect.size.width -= 20
        scrollView.frame = rect
        
        // 设置代理
        scrollView.delegate = self;
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2
        
        // 允许交互
        imageView.isUserInteractionEnabled = true
        // 添加点击手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(PictureBrowserViewCell.tapPicture))
        imageView.addGestureRecognizer(tap)
    }
}
