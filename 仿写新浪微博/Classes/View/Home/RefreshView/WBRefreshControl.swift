//
//  WBRefreshControl.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/8/3.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

private let WBRefreshControlOffset: CGFloat = -60

class WBRefreshControl: UIRefreshControl {
    
    override func beginRefreshing() {
        super.beginRefreshing()
        
        refreshView.startAnimation()
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        
        refreshView.stopAnimation()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if frame.origin.y > 0 {
            return
        }
        
        if isRefreshing {
            refreshView.startAnimation()
            return
        }
        
        if frame.origin.y < WBRefreshControlOffset && !refreshView.rotateFlag {
            print("反过来")
            refreshView.rotateFlag = true
            refreshView.tipLabel.text = "松开立即刷新"
        }else if frame.origin.y > WBRefreshControlOffset && refreshView.rotateFlag {
            print("转过去")
            refreshView.rotateFlag = false
            refreshView.tipLabel.text = "下拉刷新数据"
        }
    }
    
    // MARK: - 构造函数
    override init() {
        super.init()
        
        setupUI()
        
        // 隐藏转轮
        tintColor = UIColor.clear
        
        // 使用KVO监听frame
        DispatchQueue.main.async {
            self.addObserver(self, forKeyPath: "frame", options: [], context: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "frame")
    }

    // MARK: - 懒加载控件
    private lazy var refreshView: WBRefreshView = WBRefreshView.refreshView()
    
    // MARK: - 设置界面
    private func setupUI() {
        // 添加控件
        addSubview(refreshView)
        
        // 设置位置
        refreshView.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.size.equalTo(refreshView.bounds.size)
        }
    }
}

class WBRefreshView: UIView {
    
    @IBOutlet weak var pullImageView: UIImageView!
    @IBOutlet weak var loadImageView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var pullRefreshView: UIView!
    
    // 翻转标记
    var rotateFlag: Bool = false {
        didSet{
            rotatePullImage()
        }
    }
    
    /// 从xib加载视图
    class func refreshView() -> WBRefreshView {
        let nib = UINib(nibName: "WBRefreshView", bundle: nil)
        
        return nib.instantiate(withOwner: nil, options: nil).first as! WBRefreshView
    }
    
    private func rotatePullImage() {
        var angle = CGFloat(Double.pi)
        angle += rotateFlag ? -0.00001 : 0.00001
        
        UIView.animate(withDuration: 0.5) { 
            self.pullImageView.transform = self.pullImageView.transform.rotated(by: angle)
        }
    }
    
    fileprivate func startAnimation() {
        pullRefreshView.isHidden = true
        
        let key = "transform.rotation"
        if loadImageView.layer.action(forKey: key) != nil {
            return
        }
        
        let animation = CABasicAnimation(keyPath: key)
        animation.toValue = 2 * Double.pi
        animation.duration = 1
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        
        loadImageView.layer.add(animation, forKey: key)
        
    }
    
    fileprivate func stopAnimation() {
        pullRefreshView.isHidden = false
        
        loadImageView.layer.removeAllAnimations()
    }
    
}
