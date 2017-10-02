//
//  ComposeSwitchView.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/10/2.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class ComposeSwitchView: UIView {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var returnButtonCons: NSLayoutConstraint!
    @IBOutlet weak var closeButtonCons: NSLayoutConstraint!
    
    /// 按钮信息数组
    private let array = [["imageName": "tabbar_compose_idea", "title": "文字"],
                         ["imageName": "tabbar_compose_photo", "title": "图片/视频"],
                         ["imageName": "tabbar_compose_weibo", "title": "长微博"],
                         ["imageName": "tabbar_compose_lbs", "title": "签到"],
                         ["imageName": "tabbar_compose_review", "title": "点评"],
                         ["imageName": "tabbar_compose_more", "title": "更多"],
                         ["imageName": "tabbar_compose_friend", "title": "好友圈"],
                         ["imageName": "tabbar_compose_wbcamera", "title": "微博相机"],
                         ["imageName": "tabbar_compose_music", "title": "音乐"],
                         ["imageName": "tabbar_compose_shooting", "title": "拍摄"]]
    
    @IBAction func close() {
        removeFromSuperview()
    }
    
    @IBAction func clickReturn() {
        
    }
    
    class func show() {
        UIApplication.shared.keyWindow?.rootViewController?.view .addSubview(ComposeSwitchView.composeSwitchView())
    }

    private class func composeSwitchView() -> ComposeSwitchView {
        let nib = UINib(nibName: "ComposeSwitchView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! ComposeSwitchView
        
        view.setupUI()
        
        return view
    }

}

// MARK: - 设置界面
private extension ComposeSwitchView {
    func setupUI() {
        // 设置底部视图
        bottomView.layer.borderWidth = 0.5
        bottomView.layer.borderColor = UIColor.lightGray.cgColor
        
        // 添加按钮
        
    }
    
    func addbutton(imageName: String, title: String, superView: UIView) {
        let button = ComposeTypeButton.button(imageName: imageName, title: title)
        
        superView.addSubview(button)
    }
}
