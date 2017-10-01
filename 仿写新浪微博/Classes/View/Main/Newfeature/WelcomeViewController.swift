//
//  WelcomeViewController.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/6/10.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {
    
    override func loadView() {
        view = backImageView
        
        setupUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconImageView.sd_setImage(with: UserAccountViewModel.sharedUersAccount.avatar_largeURL, placeholderImage: UIImage(named: "avatar_default_big"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        iconImageView.snp.updateConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-view.bounds.height + 200)
        }
        
        showAnimation()
    }
    
    // MARK: - 添加动画
    func showAnimation(){
        welcomeLabel.alpha = 0
        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 0.8, delay: 0, options: [], animations: { 
                self.welcomeLabel.alpha = 1
            }, completion: { (_) in
                NotificationCenter.default.post(name:NSNotification.Name.init(WBSwitchRootViewControllerNotification), object: nil)
            })
        }
    }

    // MARK: - 懒加载控件
    /// 背景图
    fileprivate lazy var backImageView: UIImageView = UIImageView(imageName: "ad_background")
    
    /// 头像
    fileprivate lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(imageName: "avatar_default_big")
        imageView.layer.cornerRadius = 45
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    /// 欢迎文字
    fileprivate lazy var welcomeLabel: UILabel = UILabel(text: "欢迎回来", font: 18)
    
}

// MARK: - 设置界面
extension WelcomeViewController{
    
    func setupUI(){
        
        // 添加控件
        view.addSubview(iconImageView)
        view.addSubview(welcomeLabel)
        
        // 设置位置
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.snp.bottom).offset(-200)
            make.width.equalTo(90)
            make.height.equalTo(90)
        }
        
        welcomeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconImageView.snp.centerX)
            make.top.equalTo(iconImageView.snp.bottom).offset(16)
        }
    }
}
