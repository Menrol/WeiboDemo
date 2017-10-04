//
//  ComposeSwitchView.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/10/2.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit
import pop

class ComposeSwitchView: UIView {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var returnButtonCons: NSLayoutConstraint!
    @IBOutlet weak var closeButtonCons: NSLayoutConstraint!
    
    /// 动画完成回调
    private var completion: ((_ className: String?) -> ())?
    /// 按钮信息数组
    private let buttonInfo = [["imageName": "tabbar_compose_idea", "title": "文字",
                          "className": "ComposeViewController"],
                         ["imageName": "tabbar_compose_photo", "title": "图片/视频"],
                         ["imageName": "tabbar_compose_weibo", "title": "长微博"],
                         ["imageName": "tabbar_compose_lbs", "title": "签到"],
                         ["imageName": "tabbar_compose_review", "title": "点评"],
                         ["imageName": "tabbar_compose_more", "title": "更多",
                          "actionName": "clickMore", "className": ""],
                         ["imageName": "tabbar_compose_friend", "title": "好友圈"],
                         ["imageName": "tabbar_compose_wbcamera", "title": "微博相机"],
                         ["imageName": "tabbar_compose_music", "title": "音乐"],
                         ["imageName": "tabbar_compose_shooting", "title": "拍摄"]]
    
    // MARK: - 监听方法
    @objc private func clickButton(btn: ComposeTypeButton) {
        let view = currentView()
        for (i,button) in view.subviews.enumerated() {
            // 添加放大缩小动画
            let scale = btn == button ? 1.7 : 0.7
            let animation: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            animation.toValue = NSValue(cgPoint: CGPoint(x: scale, y: scale))
            animation.duration = 0.25
            button.pop_add(animation, forKey: nil)
            
            // 添加透明动画
            let alphaAnimation: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphaAnimation.toValue = 0.2
            alphaAnimation.duration = 0.25
            button.pop_add(alphaAnimation, forKey: nil)
            
            if i == 0 {
                // 动画完成回调
                animation.completionBlock = { _,_ in
                    self.completion?(btn.className)
                }
            }
        }
    }
    
    @IBAction func close() {
        // 获取当前view
        let view = currentView()
        // 判断是否是第二页
        if view.subviews.count == 4 {
            // 合并按钮
            combineButtons(completion: {
                // 显示关闭按钮动画
                self.dismissCloseButtonAnimation()
            })
        }else {
            // 显示关闭按钮动画
            dismissCloseButtonAnimation()
        }
        // 遍历view
        for (i,button) in view.subviews.enumerated().reversed() {
            let animation: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            animation.fromValue = button.center.y
            animation.toValue = button.center.y + 350
            animation.beginTime = CACurrentMediaTime() + Double(view.subviews.count - i - 1) * 0.03
            button.pop_add(animation, forKey: nil)
            
            // 完成回调
            animation.completionBlock = { _,_ in
                self.closeAnimation()
            }
        }
        
    }
    
    @IBAction func clickReturn() {
        // 滚动scrollerVIew
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        //添加动画
        combineButtons(completion: nil)
    }
    
    @objc private func clickMore() {
        // 滚动scrollView
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: true)
        
        // 显示按钮
        returnButton.isHidden = false
        
        // 添加动画
        let offset = UIScreen.main.bounds.width / 6
        returnButtonCons.constant -= offset
        closeButtonCons.constant += offset
        returnButton.alpha = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
            self.returnButton.alpha = 1
        })
    }
    
    // MARK: - 视图展示与关闭相关方法
    func show(completion: @escaping (_ className: String?) -> ()) {
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(self)
        self.completion = completion
        
        // 设置动画
        let animation: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.25
        pop_add(animation, forKey: nil)
        
        // 显示按钮
        self.showButtonsAnimation()
        
        animation.completionBlock = { _,_ in
            // 显示关闭按钮
            self.showCloseButtonAnimation()
        }
    }
    
    /// 显示按钮动画
    private func showButtonsAnimation() {
        // 获取当前view
        let view = currentView()
        // 遍历view
        for (i,button) in view.subviews.enumerated() {
            let animation: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            animation.springBounciness = 8
            animation.springSpeed = 8
            animation.fromValue = button.center.y + 350
            animation.toValue = button.center.y
            animation.beginTime = CACurrentMediaTime() + Double(i) * 0.03
            button.pop_add(animation, forKey: nil)
        }
    }
    
    /// 关闭视图动画
    func closeAnimation() {
        let animation: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        animation.toValue = 0
        animation.duration = 0.25
        self.pop_add(animation, forKey: nil)
        // 完成回调
        animation.completionBlock = { _,_ in
            self.removeFromSuperview()
        }
    }
    
    /// 显示关闭按钮动画
    private func showCloseButtonAnimation() {
        let animation: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPLayerRotation)
        animation.toValue = Double.pi / 4
        animation.duration = 0.25
        closeButton.layer.pop_add(animation, forKey: nil)
    }
    
    /// 关闭关闭按钮动画
    private func dismissCloseButtonAnimation() {
        let animation: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPLayerRotation)
        animation.toValue = -Double.pi / 2
        closeButton.layer.pop_add(animation, forKey: nil)
    }
    
    /// 合并按钮动画
    private func combineButtons(completion: (() -> Void)?) {
        let offset = UIScreen.main.bounds.width / 6
        returnButtonCons.constant += offset
        closeButtonCons.constant -= offset
        
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
            self.returnButton.alpha = 0
        }) { (_) in
            self.returnButton.isHidden = true
            self.returnButton.alpha = 1
            completion?()
        }
    }
    
    /// 获取当前view
    private func currentView() -> UIView {
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        let view = scrollView.subviews[Int(page)]
        
        return view
    }

    class func composeSwitchView() -> ComposeSwitchView {
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
        
        // 设置scrollView
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * 2, height: scrollView.bounds.height)
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
        
        // 添加按钮
        addbuttons()
    }
    
    /// 添加所有按钮
    func addbuttons() {
        let count = 6
        for var idx in 0...1 {
            let view = UIView(frame: CGRect(x: CGFloat(idx) * scrollView.bounds.width,
                                            y: 0,
                                            width: scrollView.bounds.width,
                                            height: scrollView.bounds.height))
            scrollView.addSubview(view)
            
            idx = idx == 0 ? 0 : 6
            for i in idx..<(idx + count) {
                if i == buttonInfo.count {
                    break
                }
                
                // 按钮字典
                let dic = buttonInfo[i]
                
                guard let imageName = dic["imageName"],
                    let title = dic["title"] else {
                        continue
                }
                
                // 添加按钮
                let button = addbutton(imageName: imageName, title: title, superView: view, index: i, startIdx: idx)
                // 添加监听方法
                if let actionName = dic["actionName"] {
                    button.addTarget(self, action: Selector(actionName), for: .touchUpInside)
                }else {
                    button.addTarget(self, action: #selector(clickButton(btn:)), for: .touchUpInside)
                }
                
                // 记录控制器名称
                button.className = dic["className"]
            }
        }
    }
    
    /// 添加按钮
    func addbutton(imageName: String, title: String, superView: UIView, index: Int, startIdx: Int) -> ComposeTypeButton {
        // 添加按钮
        let button = ComposeTypeButton.button(imageName: imageName, title: title)
        superView.addSubview(button)
        
        // 设置frame
        let width = button.bounds.width
        let height = button.bounds.height
        let count = 3
        let col = index % count
        let margin = (superView.bounds.width - width * CGFloat(count)) / 4
        let x = CGFloat(col + 1) * margin + CGFloat(col) * width
        let y = index > (startIdx + 2) ? margin + width : 0
        
        button.frame = CGRect(x: x, y: y, width: width, height: height)
        
        return button
    }
}
