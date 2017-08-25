//
//  PictureBrowserViewController.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/8/24.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

/// 可重用cellId
let PictureBrowserViewCellId = "PictureBrowserViewCellId"

class PictureBrowserViewController: UIViewController {
    /// 选中图片索引
    var indexPath: IndexPath
    /// 选中图片数组
    var thumbnailUrls: [URL]
    
    // MARK: - 监听方法
    @objc fileprivate func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func save() {
        print("保存图片")
    }

    // MARK: - 构造函数
    init(indexPath: IndexPath, thumbnailUrls: [URL]) {
        self.indexPath = indexPath
        self.thumbnailUrls = thumbnailUrls
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 控制器生命周期
    override func loadView() {
        var rect = UIScreen.main.bounds
        rect.size.width += 20
        view = UIView(frame: rect)
        
        setupUI()
    }
    
    // MARK: - 懒加载控件
    fileprivate lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PictureBrowserViewLayout())
    fileprivate lazy var saveButton: UIButton = UIButton(title: "保存", imageName: nil, backColor: UIColor.darkGray, fontSize: 14, color: UIColor.white)
    fileprivate lazy var closeButton: UIButton = UIButton(title: "关闭", imageName: nil, backColor: UIColor.darkGray, fontSize: 14, color: UIColor.white)
    
    /// 自定义布局
    class PictureBrowserViewLayout: UICollectionViewFlowLayout {
        override func prepare() {
            super.prepare()
            
            itemSize = collectionView!.bounds.size
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            scrollDirection = .horizontal
            
            collectionView?.showsHorizontalScrollIndicator = false
            collectionView?.isPagingEnabled = true
            collectionView?.bounces = false
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PictureBrowserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbnailUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureBrowserViewCellId, for: indexPath) as! PictureBrowserViewCell
        
        cell.imageUrl = thumbnailUrls[indexPath.item]
        
        return cell
    }
}

// MARK: - 设置界面
fileprivate extension PictureBrowserViewController {
    func setupUI() {
        // 添加控件
        view.addSubview(collectionView)
        view.addSubview(saveButton)
        view.addSubview(closeButton)
        
        // 设置布局
        let margin = UIScreen.main.scale * 4
        
        collectionView.frame = view.bounds
        
        closeButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-margin)
            make.left.equalTo(view.snp.left).offset(margin)
            make.size.equalTo(CGSize(width: 100, height: 36))
        }
        
        saveButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-margin)
            make.right.equalTo(view.snp.right).offset(-margin)
            make.size.equalTo(CGSize(width: 100, height: 36))
        }
        
        // 监听方法
        closeButton.addTarget(self, action: #selector(PictureBrowserViewController.close), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(PictureBrowserViewController.save), for: .touchUpInside)
        
        // 准备collectionview
        prepareCollectionView()
    }
    
    func prepareCollectionView() {
        collectionView.register(PictureBrowserViewCell.self, forCellWithReuseIdentifier: PictureBrowserViewCellId)
        
        collectionView.dataSource = self
    }
}
