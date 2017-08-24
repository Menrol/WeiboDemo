//
//  PicturePickerController.swift
//  照片选择
//
//  Created by Apple on 2017/8/23.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

/// 可重用cellId
private let PicturePickerViewCellId = "PicturePickerViewCellId"
/// 最大照片数
fileprivate let MaxPictureCount = 9

class PicturePickerController: UICollectionViewController {
    /// 选中照片
    fileprivate var selectedIndex = 0
    
    /// 图片数组
    fileprivate lazy var pictures: [UIImage] = {
        var images = [UIImage]()
        images.append(self.addImage)
        
        return images
    }()
    
    /// 加号图片
    lazy var addImage: UIImage = UIImage(named: "compose_pic_add")!
    
    // MARK: - 构造函数
    init() {
        super.init(collectionViewLayout: PicturePickerLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 控制器生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置背景颜色
        collectionView?.backgroundColor = UIColor(white: 0.9, alpha: 1)

        // 注册可重用cell
        collectionView!.register(PicturePickerCell.self, forCellWithReuseIdentifier: PicturePickerViewCellId)
    }
    
    /// 照片选择布局
    class PicturePickerLayout: UICollectionViewFlowLayout {
        override func prepare() {
            let count: CGFloat = 4
            let margin = UIScreen.main.scale * 4
            let width = (UIScreen.main.bounds.width - margin * (count + 1)) / count
            
            itemSize = CGSize(width: width, height: width)
            minimumLineSpacing = margin
            minimumInteritemSpacing = margin
            sectionInset = UIEdgeInsetsMake(margin, margin, 0, margin)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PicturePickerController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PicturePickerViewCellId, for: indexPath) as! PicturePickerCell
        
        cell.pictureDelegate = self
        cell.image = (indexPath.item == pictures.count) ? nil : pictures[indexPath.item]
        cell.addButton.isHidden = (indexPath.item == MaxPictureCount)
        
        return cell
    }
}

// MARK: - PicturePickerCellDelegate
extension PicturePickerController: PicturePickerCellDelegate {
    fileprivate func picturePickerCellDidAdd(cell: PicturePickerCell) {
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            print("无法访问照片")
            
            return
        }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        selectedIndex = collectionView?.indexPath(for: cell)?.item ?? 0
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    fileprivate func picturePickerCellDidDelete(cell: PicturePickerCell) {
        let deletedIndexPath = collectionView?.indexPath(for: cell)
        pictures.remove(at: deletedIndexPath!.item)
        
        collectionView?.deleteItems(at: [deletedIndexPath!])
        
        if deletedIndexPath!.item == MaxPictureCount - 1 {
            pictures.append(addImage)
            collectionView?.insertItems(at: [deletedIndexPath!])
        }
    }
}

// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate
extension PicturePickerController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        let scaleImage = image.scaleToWidth(width: 600)
        
        if selectedIndex == pictures.count - 1 {
            pictures[selectedIndex] = scaleImage
            if selectedIndex < MaxPictureCount - 1 {
                pictures.append(addImage)
            }
        }else {
            pictures[selectedIndex] = scaleImage
        }
        
        // 刷新数据
        collectionView?.reloadData()
        
        // 释放控制器
        dismiss(animated: true, completion: nil)
    }
}

@objc
private protocol PicturePickerCellDelegate: NSObjectProtocol {
    /// 添加照片
    @objc optional func picturePickerCellDidAdd(cell: PicturePickerCell);
    /// 删除照片
    @objc optional func picturePickerCellDidDelete(cell: PicturePickerCell);
}

/// 照片选择cell
class PicturePickerCell: UICollectionViewCell {
    /// 图片
    fileprivate var image: UIImage? {
        didSet{
            let data1 = UIImagePNGRepresentation(UIImage(named: "compose_pic_add")!)
            let data2 = UIImagePNGRepresentation(image!)
            
            deleteButton.isHidden = (data1 == data2)
            addButton.setImage(image, for: .normal)
        }
    }
    
    /// 照片代理
    fileprivate weak var pictureDelegate: PicturePickerCellDelegate?
    
    // MARK: - 监听方法
    @objc private func addPicture() {
        pictureDelegate?.picturePickerCellDidAdd?(cell: self)
    }
    
    @objc private func deletePicture() {
        pictureDelegate?.picturePickerCellDidDelete?(cell: self)
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
    lazy var addButton: UIButton = UIButton(imageName: "compose_pic_add", backgroundImageName: nil)
    private lazy var deleteButton: UIButton = UIButton(imageName: "compose_card_delete_normal", backgroundImageName: nil, backColor: UIColor(white: 0.4, alpha: 0.5))
    
    // MARK: - 设置界面
    private func setupUI() {
        // 添加控件
        contentView.addSubview(addButton);
        contentView.addSubview(deleteButton);
        
        // 设置布局
        addButton.frame = bounds
        
        deleteButton.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.right.equalTo(contentView.snp.right)
        }
        
        // 设置填充模式
        addButton.imageView?.contentMode = .scaleAspectFill
        
        // 监听方法
        addButton.addTarget(self, action: #selector(PicturePickerCell.addPicture), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(PicturePickerCell.deletePicture), for: .touchUpInside)
    }
}


