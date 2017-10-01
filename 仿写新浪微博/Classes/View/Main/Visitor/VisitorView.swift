//
//  VisitorView.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/5/22.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class VisitorView: UIView {
    
    // MARK: - 设置视图信息
    func setvisitorView(imageName: String?, message:String){
        messageLabel.text = message
        guard let imgName = imageName else {
            setAnimation()
            return
        }
        iconImageView.image = UIImage(named: imgName)
        homeiconImageView.isHidden = true
        sendSubview(toBack: maskImageView)
    }
    
    // MARK: - 设置动画
    private func setAnimation(){
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = 2 * Double.pi
        animation.duration = 20
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        
        iconImageView.layer.add(animation, forKey: nil)
    }

    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    // storyboard构造函数
    required init?(coder aDecoder: NSCoder) {
        
        // 使用storyboard会崩溃
        fatalError("init(coder:) has not been implemented")
        
    }
    
    // MARK: - 懒加载控件
    fileprivate lazy var iconImageView: UIImageView = UIImageView(imageName: "visitordiscover_feed_image_smallicon")
    
    fileprivate lazy var maskImageView: UIImageView = UIImageView(imageName: "visitordiscover_feed_mask_smallicon")
    
    fileprivate lazy var homeiconImageView: UIImageView = UIImageView(imageName: "visitordiscover_feed_image_house")
    
    fileprivate lazy var messageLabel: UILabel = UILabel(text: nil)
    
    lazy var registerButton: UIButton = UIButton(title: "注册", backImageName: "common_button_white_disable",color: UIColor.orange)
    
    lazy var loginButton: UIButton = UIButton(title: "登录", backImageName: "common_button_white_disable")
    
}

// MARK: - 设置界面
extension VisitorView{
    
    // 设置UI
    fileprivate func setUI(){
        
        // 添加控件
        addSubview(iconImageView)
        addSubview(maskImageView)
        addSubview(homeiconImageView)
        addSubview(messageLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        for v in subviews{
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // 设置自动布局
        // 转轮
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -60))
        
        // 房子
        addConstraint(NSLayoutConstraint(item: homeiconImageView, attribute: .centerX, relatedBy: .equal, toItem: iconImageView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: homeiconImageView, attribute: .centerY, relatedBy: .equal, toItem: iconImageView, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        // 提示文字
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .top, relatedBy: .equal, toItem: iconImageView, attribute: .bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 224))
        
        // 注册按钮
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .left, relatedBy: .equal, toItem: messageLabel, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .top, relatedBy: .equal, toItem: messageLabel, attribute: .bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 36))
        
        // 登录按钮
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .right, relatedBy: .equal, toItem: messageLabel, attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .top, relatedBy: .equal, toItem: messageLabel, attribute: .bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 36))
        
        // 遮盖图
        /**
           VFL : 可视化格式语言
           H 水平方向
           V 垂直方向
           | 边界
           [] 包装控件
           views: 是一个字典 [名字:控件名]
        */
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[mask]-0-|", options: [], metrics: nil, views: ["mask":maskImageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[mask]-(H)-[regnbtn]", options: [], metrics: ["H":-36], views: ["mask":maskImageView,"regnbtn":registerButton]))
        
        backgroundColor = UIColor(white: 237/255.0, alpha: 1.0)
    }
}
