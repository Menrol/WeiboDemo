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
    fileprivate lazy var packages = EmoticonManage.sharedManager.packages
    
    /// 点击回调
    fileprivate var selectedEmoticonCallBack: (_ emoticon: Emoticon) -> ()
    
    /// 监听方法
    @objc fileprivate func clickItem(item: UIBarButtonItem) {
        let indexPath = IndexPath(item: 0, section: item.tag)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }

    // MARK: - 构造函数
    init(selectedEmoticon: @escaping (_ emoticon: Emoticon) -> ()) {
        selectedEmoticonCallBack = selectedEmoticon
        
        var rect = UIScreen.main.bounds
        rect.size.height = 226
        super.init(frame: rect)
        
        setupUI()
        
        backgroundColor = UIColor.red
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: 0, section: 1)
            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载控件
    fileprivate lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonLayout())
    fileprivate lazy var toolBar: UIToolbar = UIToolbar()
    
    // MARK: - 自定义布局
    private class EmoticonLayout: UICollectionViewFlowLayout {
        
        override func prepare() {
            super.prepare()
            
            let col: CGFloat = 7
            let row: CGFloat = 3
            let width = collectionView!.bounds.width / col
            let margin = (collectionView!.bounds.height - row * width) * 0.499
            
            itemSize = CGSize(width: width, height: width)
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            sectionInset = UIEdgeInsetsMake(margin, 0, margin, 0)
            scrollDirection = .horizontal
            collectionView?.showsHorizontalScrollIndicator = false
            collectionView?.isPagingEnabled = true
            collectionView?.bounces = false
        }
    }
}

// MARK: - UICollectionViewDataSource
extension EmoticonView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonViewCellId, for: indexPath) as! EmoticonViewCell
        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.red : UIColor.green
        
        cell.emoticon = packages[indexPath.section].emoticons[indexPath.row]
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension EmoticonView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoticon = packages[indexPath.section].emoticons[indexPath.row]
        
        selectedEmoticonCallBack(emoticon)
    }
}

// MARK: - 设置界面
private extension EmoticonView {
    func setupUI() {
        // 添加控件
        addSubview(collectionView)
        addSubview(toolBar)
        
        // 设置位置
        toolBar.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(toolBar.snp.top)
        }
        
        // 准备toolbar
        prepareToolBar()
        
        // 准备collectionview
        prepareCollectionView()
        
    }
    
    func prepareCollectionView() {
        collectionView.backgroundColor = UIColor.lightGray
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EmoticonViewCell.self, forCellWithReuseIdentifier: EmoticonViewCellId)
    }
    
    func prepareToolBar() {
        toolBar.tintColor = UIColor.darkGray
        
        var index = 0
        var items = [UIBarButtonItem]()
        
        for p in packages {
            items.append(UIBarButtonItem(title: p.group_name_cn, style: .plain, target: self, action: #selector(EmoticonView.clickItem)))
            items.last?.tag = index
            index += 1
            
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        
        toolBar.items = items
    }
}

// MARK: - 表情视图Cell
class EmoticonViewCell: UICollectionViewCell {
    
    var emoticon: Emoticon? {
        didSet{
            emoticonButton.setImage(UIImage(contentsOfFile: emoticon!.path), for: .normal)
            
            emoticonButton.setTitle(emoticon?.emoji, for: .normal)
            
            if emoticon!.isDelete {
                emoticonButton.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
            }
        }
    }
    
    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(emoticonButton)
        
        emoticonButton.frame = bounds.insetBy(dx: 4, dy: 4)
        
        emoticonButton.backgroundColor = UIColor.white
        emoticonButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        emoticonButton.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载控件
    private lazy var emoticonButton: UIButton = UIButton()
}
