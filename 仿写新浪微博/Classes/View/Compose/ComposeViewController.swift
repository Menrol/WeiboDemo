//
//  ComposeViewController.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/8/16.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {
    
    // MARK: - 监听方法
    @objc fileprivate func close() {
        // 关闭键盘
        textView.resignFirstResponder()
        // 关闭控制器
        dismiss(animated: true, completion: nil);
    }
    
    @objc fileprivate func sendStatus() {
        // 获取文本内容
        let text = textView.emoticonText!
        let image = picturePickerController.pictures.first
        // 发布微博
        NetworkTool.sharedTool.sendStatus(status: text, image: image) { (result, error) in
            if error != nil {
                SVProgressHUD.showInfo(withStatus: "网络不给力")
                print("出错了")
                return
            }
            
            // 关闭控制器
            self.close()
        }
        
    }
    
    @objc fileprivate func selectEmoticon() {
        // 收回键盘
        textView.resignFirstResponder()
        // 替换键盘
        textView.inputView = textView.inputView == nil ? emoticonView : nil
        // 打开键盘
        textView.becomeFirstResponder()
    }
    
    @objc fileprivate func picturePicker() {
        
        // 收起键盘
        textView.resignFirstResponder()
        
        // 判断是否已经更新约束
        if picturePickerController.view.frame.height > 0 {
            return
        }
        
        // 更新约束
        picturePickerController.view.snp.updateConstraints { (make) in
            make.height.equalTo(view.bounds.height * 0.6)
        }
        
        textView.snp.remakeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(picturePickerController.view.snp.top)
        }
        
        // 设置动画
        UIView.animate(withDuration: 0.5) { 
            self.view.layoutIfNeeded()
        }
    }
    
    @objc fileprivate func keyboardChange(notification: Notification) {
        // 动画时间
        let duration = notification.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! TimeInterval
        let rect = (notification.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        let offset = -UIScreen.main.bounds.height + rect.origin.y
        // 动画曲线数值
        let curve = (notification.userInfo!["UIKeyboardAnimationCurveUserInfoKey"] as! NSNumber).intValue
        
        // 更新约束
        toolBar.snp.updateConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(offset)
        }
        
        // 动画
        UIView.animate(withDuration: duration) {
            // 设置动画曲线
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve)!)
            
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - 视图生命周期
    override func loadView() {
        view = UIView()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if picturePickerController.view.frame.height == 0 {
            textView.becomeFirstResponder()
        }
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
        // 设置代理
        textView.delegate = self
        
        return textView
    }()
    fileprivate lazy var placeHolderLabel: UILabel = UILabel(text: "分享新鲜事...", font: 18, textColor: UIColor.lightGray)
    private lazy var emoticonView: EmoticonView = EmoticonView { [weak self] (emoticon) in
        self?.textView.insertEmoticon(emoticon: emoticon)
    }
    fileprivate lazy var picturePickerController: PicturePickerController = PicturePickerController()
    
}

// MARK: - UITextViewDelegate
extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
        placeHolderLabel.isHidden = textView.hasText
    }
}

// MARK: - 设置界面
private extension ComposeViewController {
    /// 设置界面
    func setupUI() {
        // 取消自动调整间距
        automaticallyAdjustsScrollViewInsets = false
        
        // 设置背景颜色
        view.backgroundColor = UIColor.white
        
        // 设置控件
        prepareNavigationBar()
        prepareToolBar()
        prepareTextView()
        preparePicturePicker()
    }
    
    /// 准备照片选择器
    func preparePicturePicker() {
        // 添加子控制器
        addChildViewController(picturePickerController)
        
        // 添加子控件
        view.insertSubview(picturePickerController.view, belowSubview: toolBar)
        
        // 设置布局
        picturePickerController.view.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(0)
        }
    }
    
    /// 准备导航栏
    func prepareNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(ComposeViewController.close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(ComposeViewController.sendStatus))
        
        // 禁用发送按钮
        navigationItem.rightBarButtonItem?.isEnabled = false
        
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
            var offSet: CGFloat
            if #available(iOS 11.0, *) {
                offSet = -12
            }else {
                offSet = 0
            }
            make.top.equalTo(titleView.snp.top).offset(offSet)
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
        
        let dicArray = [["imageName": "compose_toolbar_picture", "actionName": "picturePicker"],
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
        
        // 添加占位标签
        textView.addSubview(placeHolderLabel)
        
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.top).offset(8)
            make.left.equalTo(textView.snp.left).offset(5)
        }
    }
}
