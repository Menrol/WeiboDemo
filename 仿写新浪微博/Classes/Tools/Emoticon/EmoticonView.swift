//
//  EmoticonView.swift
//  Emoticon
//
//  Created by Apple on 2017/8/10.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

/// 可重用CellID
private let EmoticonViewCellId = "EmoticonViewCellId"

class EmoticonView: UIView {
    
    /// 表情包数组
    fileprivate lazy var packages = EmoticonManager.sharedManager.packages
    /// 点击回调
    fileprivate var selectedEmoticonCallBack: (_ emoticon: Emoticon) -> ()
    
    // MARK: - 监听方法
    @objc fileprivate func clickItem(button: UIButton) {
        // 取消所有选中状态
        for button in toolBar.subviews as! [UIButton] {
            button.isSelected = false
        }
        // 设置选中状态
        button.isSelected = true
        
        // 滚动
        let indexPath = IndexPath(item: 0, section: button.tag)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }

    // MARK: - 构造函数
    init(selectedEmoticon: @escaping (_ emoticon: Emoticon) -> ()) {
        selectedEmoticonCallBack = selectedEmoticon
        
        var rect = UIScreen.main.bounds
        rect.size.height = 226
        super.init(frame: rect)
        
        setupUI()
        
        backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载控件
    fileprivate lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonLayout())
    fileprivate lazy var toolBar: UIView = UIView()
    fileprivate lazy var pageControl: UIPageControl = UIPageControl()
    
    // MARK: - 自定义布局
    private class EmoticonLayout: UICollectionViewFlowLayout {
        
        override func prepare() {
            super.prepare()
            
            guard let collectionView = collectionView else {
                return
            }
            
            itemSize = collectionView.bounds.size
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            scrollDirection = .horizontal
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.isPagingEnabled = true
            collectionView.bounces = false
        }
    }
}

// MARK: - UICollectionViewDataSource
extension EmoticonView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonViewCellId, for: indexPath) as! EmoticonViewCell
        
        cell.emoticons = packages[indexPath.section].emoticons(page: indexPath.item)
        cell.emoticonCellDelegate = self
        
        return cell
    }
}

// MARK: - EmoticonViewCellDelegate
extension EmoticonView: EmoticonViewCellDelegate {
    func didSelectEmoticon(emoticon: Emoticon) {
        selectedEmoticonCallBack(emoticon)
        
        // 判断是否是第0分组
        let indexPath = collectionView.indexPathsForVisibleItems[0]
        if indexPath.section == 0 {
            return
        }
        
        // 添加最近使用表情
        EmoticonManager.sharedManager.addRecentEmoticon(emoticon: emoticon)
        
        // 刷新数据
        var indexSet = IndexSet()
        indexSet.insert(0)
        collectionView.reloadSections(indexSet)
    }
}

// MARK: - 设置界面
private extension EmoticonView {
    func setupUI() {
        // 添加控件
        addSubview(collectionView)
        addSubview(toolBar)
        addSubview(pageControl)
        
        // 设置位置
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: toolBar,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .left,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: toolBar,
                                         attribute: .right,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .right,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: toolBar,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: toolBar,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1,
                                         constant: 44))
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: collectionView,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: collectionView,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .left,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: collectionView,
                                         attribute: .right,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .right,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: collectionView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: toolBar,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: 0))
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: pageControl,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: pageControl,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: toolBar,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: 8))
        
        
        // 准备toolbar
        prepareToolBar()
        // 准备collectionview
        prepareCollectionView()
        // 准备分页控件
        preparePageControl()
    }
    
    func preparePageControl() {
        pageControl.numberOfPages = 4
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        pageControl.pageIndicatorTintColor = UIColor.lightGray
    }
    
    func prepareCollectionView() {
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.register(EmoticonViewCell.self, forCellWithReuseIdentifier: EmoticonViewCellId)
    }
    
    func prepareToolBar() {
        // 更新约束
        layoutIfNeeded()
        // 背景颜色
        toolBar.backgroundColor = UIColor.white
        
        // 添加所有按钮
        let w = toolBar.bounds.width / CGFloat(packages.count)
        let rect = CGRect(x: 0, y: 0, width: w, height: toolBar.bounds.height)
        for (i,p) in packages.enumerated() {
            let button = UIButton()
            
            // 获取图像
            let bundle = EmoticonManager.sharedManager.bundle
            let imageName = "compose_emotion_table_\(p.bgImageName ?? "")_normal"
            let imageNameHL = "compose_emotion_table_\(p.bgImageName ?? "")_selected"
            var image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
            var imageHL = UIImage(named: imageNameHL, in: bundle, compatibleWith: nil)
            
            // 拉伸图像
            let size = image?.size ?? CGSize()
            let inset = UIEdgeInsetsMake(size.height * 0.5, size.width * 0.5, size.height * 0.5, size.width * 0.5)
            image = image?.resizableImage(withCapInsets: inset)
            imageHL = imageHL?.resizableImage(withCapInsets: inset)
            
            // 设置标题
            button.setTitle(p.groupName, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.setTitleColor(UIColor.darkGray, for: .highlighted)
            button.setTitleColor(UIColor.darkGray, for: .selected)
            button.setTitleColor(UIColor.white, for: .normal)
            
            // 设置背景
            button.setBackgroundImage(image, for: .normal)
            button.setBackgroundImage(imageHL, for: .selected)
            button.setBackgroundImage(imageHL, for: .highlighted)
            
            // 添加按钮
            toolBar.addSubview(button)
            
            // 设置位置
            button.frame = rect.offsetBy(dx: CGFloat(i) * w, dy: 0)
            
            button.tag = i
            
            // 添加监听方法
            button.addTarget(self, action: #selector(clickItem(button:)), for: .touchUpInside)
            
            // 选中第一个按钮
            if i == 0 {
                button.isSelected = true
            }
        }
    }
}
