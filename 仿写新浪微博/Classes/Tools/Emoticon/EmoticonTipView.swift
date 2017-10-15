//
//  EmoticonTipView.swift
//  Emoticon
//
//  Created by Apple on 2017/10/15.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit


class EmoticonTipView: UIImageView {
    
    /// 之前的表情
    var preEmoticon: Emoticon?
    /// 选中的表情
    var emoticon: Emoticon? {
        didSet {
            if preEmoticon == emoticon {
                return
            }
            
            // 记录当前表情
            preEmoticon = emoticon
            
            // 设置表情
            button.setImage(UIImage(contentsOfFile: emoticon!.path), for: .normal)
            button.setTitle(emoticon?.emoji, for: .normal)
            
            // 添加动画
//            let animation =
        }
    }

    // MARK: - 构造函数
    init() {
        let bundle = EmoticonManager.sharedManager.bundle
        let image = UIImage(named: "emoticon_keyboard_magnifier", in: bundle, compatibleWith: nil)
        
        super.init(image: image)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载控件
    private lazy var button = UIButton()
    
}

// MARK: - 设置界面
private extension EmoticonTipView {
    func setupUI() {
        // 添加控件
        addSubview(button)
        
        // 设置位置
        button.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        button.frame = CGRect(x: 0, y: 8, width: 36, height: 36)
        button.center.x = bounds.width * 0.5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
    }
}
