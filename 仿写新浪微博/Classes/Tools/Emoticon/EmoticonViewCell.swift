//
//  EmoticonViewCell.swift
//  Emoticon
//
//  Created by Apple on 2017/10/12.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

/// 点击表情代理
protocol EmoticonViewCellDelegate: NSObjectProtocol {
    func didSelectEmoticon(emoticon: Emoticon)
}

class EmoticonViewCell: UICollectionViewCell {
    /// 表情数组
    var emoticons: [Emoticon]? {
        didSet{
            for button in contentView.subviews {
                button.isHidden = true
            }
            
            for (i, em) in (emoticons ?? []).enumerated() {
                
                if em.isEmpty {
                    continue
                }
                
                // 获取按钮
                let button = contentView.subviews[i] as! UIButton
                button.isHidden = false
                
                // 设置表情
                button.setImage(UIImage(contentsOfFile: em.path), for: .normal)
                button.setTitle(em.emoji, for: .normal)
                
                if em.isDelete {
                    button.setImage(UIImage.init(contentsOfFile: em.deletePath), for: .normal)
                }
            }
        }
    }
    /// 代理
    weak var emoticonCellDelegate: EmoticonViewCellDelegate?
    
    // MARK: - 监听方法
    @objc private func selectEmoticon(button: UIButton) {
        let emoticon = emoticons![button.tag]
        emoticonCellDelegate?.didSelectEmoticon(emoticon: emoticon)
    }
    
    @objc private func longPress(gesture: UILongPressGestureRecognizer) {
        // 获取位置
        let location = gesture.location(in: self)
        // 获取按钮
        guard let btn = button(WithLocation: location) else {
            tipView.isHidden = true
            return
        }
        
        // 设置表情
        switch gesture.state {
        case .began,.changed:
            tipView.isHidden = false
            
            // 坐标系转换
            let center = convert(btn.center, to: window)
            tipView.center = center
            // 设置锚点
            tipView.layer.anchorPoint = CGPoint(x: 0.5, y: 1.2)
            
            // 设置表情
            let emoticon = emoticons?[btn.tag]
            tipView.emoticon = emoticon
        case .ended:
            selectEmoticon(button: btn)
            tipView.isHidden = true
        case .cancelled,.failed:
            tipView.isHidden = true
        default:
            break
        }
    }
    
    
    private func button(WithLocation location: CGPoint) -> UIButton? {
        // 遍历所有子视图
        for btn in contentView.subviews as! [UIButton] {
            if btn.frame.contains(location) && !btn.isHidden && btn != contentView.subviews.last {
                return btn
            }
        }
        
        return nil
    }
    
    // MARK: - 视图生命周期
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        guard let window = newWindow else {
            return
        }
        
        window.addSubview(tipView)
        tipView.isHidden = true
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
    private lazy var tipView = EmoticonTipView()
}

// MARK: - 设置界面
private extension EmoticonViewCell {
    func setupUI() {
        let colCount = 7
        let rowCount = 3
        let leftMargin: CGFloat = 8
        let bottomMargin: CGFloat = 16
        
        let w = (bounds.width - 2 * leftMargin) / CGFloat(colCount)
        let h = (bounds.height - bottomMargin) / CGFloat(rowCount)
        
        // 添加按钮
        for i in 0..<21 {
            let row = i / colCount
            let col = i % colCount
            
            let x = CGFloat(col) * w + leftMargin
            let y = CGFloat(row) * h
            
            let button = UIButton()
            button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            button.frame = CGRect(x: x, y: y, width: w, height: h)
            
            contentView.addSubview(button)
            
            button.tag = i
            
            // 添加监听方法
            button.addTarget(self, action: #selector(selectEmoticon(button:)), for: .touchUpInside)
        }
        
        // 添加长按手势
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        longGesture.minimumPressDuration = 0.1
        addGestureRecognizer(longGesture)
    }
}
