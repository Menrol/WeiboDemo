//
//  ComposeViewController.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/8/16.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    // MARK: - 监听方法
    @objc fileprivate func close() {
        // 关闭键盘
        textView.resignFirstResponder()
        // 关闭控制器
        dismiss(animated: true, completion: nil);
    }
    
    @objc fileprivate func sendStatus() {
        print("发送微博")
    }
    
    @objc fileprivate func selectEmoticon() {
        print("选择表情")
    }
    
    @objc fileprivate func keyboardChange(notification: Notification) {
        print(notification)
        let duration = notification.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! TimeInterval
        let rect = (notification.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        let offset = -UIScreen.main.bounds.height + rect.origin.y
        // 设置动画曲线
//        let curve = notification.userInfo!["UIKeyboardAnimationCurveUserInfoKey"] as! Double
        
        // 更新约束
        toolBar.snp.updateConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(offset)
        }
        
        // 动画
        UIView.animate(withDuration: duration) { 
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - 视图生命周期
    override func loadView() {
        view = UIView()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textView.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.keyboardChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 懒加载控件
    fileprivate lazy var toolBar: UIToolbar = UIToolbar()
    fileprivate lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        // 允许垂直滚动
        textView.alwaysBounceVertical = true
        // 滚动关闭键盘
        textView.keyboardDismissMode = .onDrag
        
        return textView
    }()
    fileprivate lazy var placeHolderLabel: UILabel = UILabel(text: "分享新鲜事...", font: 18, textColor: UIColor.lightGray)
}

// MARK: - 设置界面
private extension ComposeViewController {
    /// 设置界面
    func setupUI() {
        // 设置背景颜色
        view.backgroundColor = UIColor.white
        
        // 设置控件
        prepareNavigationBar()
        prepareToolBar()
        prepareTextView()
    }
    
    /// 准备导航栏
    func prepareNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(ComposeViewController.close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(ComposeViewController.sendStatus))
        
        // 标题视图
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 36))
        navigationItem.titleView = titleView
        
        // 设置子控件
        let sendLabel = UILabel(text: "发微博", font: 15, textColor: UIColor.black)
        let nameLabel = UILabel(text: UserAccountViewModel.sharedUersAccount.userAccount?.screen_name, font: 13, textColor: UIColor.lightGray)
        
        // 添加子空间
        titleView.addSubview(sendLabel)
        titleView.addSubview(nameLabel)
        
        // 设置约束
        sendLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.top)
            make.centerX.equalTo(titleView.snp.centerX)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(sendLabel.snp.bottom)
            make.centerX.equalTo(sendLabel.snp.centerX)
        }
    }
    
    /// 准备toolBar
    func prepareToolBar() {
        // 设置背景颜色
        toolBar.backgroundColor = UIColor(white: 0.8, alpha: 1)
        
        // 添加控件
        view.addSubview(toolBar)
        
        // 设置约束
        toolBar.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(44)
        }
        
        let dicArray = [["imageName": "compose_toolbar_picture"],
                        ["imageName": "compose_mentionbutton_background"],
                        ["imageName": "compose_trendbutton_background"],
                        ["imageName": "compose_emoticonbutton_background","actionName": "selectEmoticon"],
                        ["imageName": "compose_addbutton_background"]]
        var items = [UIBarButtonItem]()
        
        for dic in dicArray {
            items.append(UIBarButtonItem(imageName: dic["imageName"]!, target: self, actionName: dic["actionName"]))
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        
        toolBar.items = items
    }
    
    /// 准备TextView
    func prepareTextView() {
        // 添加控件
        view.addSubview(textView)
        
        // 设置布局
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(toolBar.snp.top)
        }
        
        textView.text = "分享新鲜事..."
        
        // 添加占位标签
        textView.addSubview(placeHolderLabel)
        
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.top).offset(8)
            make.left.equalTo(textView.snp.left).offset(5)
        }
    }
}
