//
//  NewfeatureCollectionViewController.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/6/5.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit
import SnapKit

/// 可重用cellid
private let WBNewFeatureCellId = "WBNewFeatureCellId"
/// 图片个数
private let WBNewFeatureImageCount = 4

class NewfeatureCollectionViewController: UICollectionViewController {
    
    // MARK: - 构造函数
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UIScreen.main.bounds.size
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 注册可重用Cell
        collectionView!.register(NewFeatureCell.self, forCellWithReuseIdentifier: WBNewFeatureCellId)
        
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
    }

    // MARK:  - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WBNewFeatureImageCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WBNewFeatureCellId, for: indexPath) as! NewFeatureCell
        
        cell.imageIndex = indexPath.item
        
        return cell
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        if page == WBNewFeatureImageCount - 1 {
            let cell = collectionView?.cellForItem(at: IndexPath(item: page, section: 0)) as? NewFeatureCell
            cell?.showAnimation()
        }
    }
}

// MARK: - 新特性cell
private class NewFeatureCell: UICollectionViewCell {
    
    /// 监听方法
    @objc private func pressstartButton(){
        print("开始体验")
    }
    
    /// 图片属性
    fileprivate var imageIndex:Int = 0{
        didSet{
            iconImageView.image = UIImage(named: "new_feature_\(imageIndex + 1)")
            
            // 隐藏按钮
            startButton.isHidden = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置动画
    fileprivate func showAnimation(){
        startButton.isHidden = false
        startButton.isUserInteractionEnabled = false
        startButton.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 1.6,            // 动画时长
                       delay: 0,                     // 延时时间
                       usingSpringWithDamping: 0.8,  // 弹力系数，0-1，越小越弹
                       initialSpringVelocity: 10,    // 初始速度，模拟重力加速度
                       options: [],                  // 动画选项
                       animations: {
            self.startButton.transform = CGAffineTransform.identity
        }) { (_) in
            self.startButton.isUserInteractionEnabled = true
        }
    }
    
    /// 设置界面
    fileprivate func setupUI(){
        // 添加控件
        addSubview(iconImageView)
        addSubview(startButton)
        
        // 指定位置
        iconImageView.frame = bounds
        
        startButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom).multipliedBy(0.7)
        }
        
        // 添加监听方法
        startButton.addTarget(self, action: #selector(NewFeatureCell.pressstartButton), for: .touchUpInside)
    }
    
    // MARK: - 懒加载控件
    /// 图片
    fileprivate lazy var iconImageView = UIImageView()
    /// 按钮
    fileprivate lazy var startButton = UIButton(title: "开始体验", imageName: "new_feature_finish_button", color: UIColor.white)
    
}
