//
//  RQRefreshControl.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/10/1.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

/// 刷新状态
enum RQRefreshState {
    case Normal
    case Pulling
    case WilRefresh
}

class RQRefreshControl: UIControl {
    
    /// 刷新状态临界点
    private let RQRefreshOffset: CGFloat = 60
    /// 滚动视图
    private weak var scrollView: UIScrollView?
    /// 顶部间距
    private var originalInset: UIEdgeInsets?
    
    /// 开始刷新
    func beginRefreshing() {
        guard let sv = scrollView else {
            return
        }
        
        if refreshView.refreshState == .WilRefresh {
            return
        }
        
        refreshView.refreshState = .WilRefresh
        
        let topInset = (originalInset?.top ?? 0) + RQRefreshOffset
        sv.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    }
    
    /// 结束刷新
    func endRefreshing() {
        guard let sv = scrollView else {
            return
        }
        
        if refreshView.refreshState != .WilRefresh  {
            return
        }
        
        refreshView.refreshState = .Normal
        
        sv.contentInset = UIEdgeInsets(top: originalInset?.top ?? 0, left: 0, bottom: 0, right: 0)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let superView = newSuperview as? UIScrollView else {
            return
        }
        
        scrollView = superView
        
        originalInset = scrollView?.contentInset
        
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let sv = scrollView else {
            return
        }
        
        let height = -(sv.contentOffset.y + sv.contentInset.top)
        
        self.frame = CGRect(x: 0, y: -height, width: sv.bounds.width, height: height)
        
        if sv.contentOffset.y > 0 {
            return
        }
        
        let topInset = originalInset?.top ?? 0
        var lastHeight: CGFloat = 0
        
        if sv.isDragging {
            if height <= RQRefreshOffset && refreshView.refreshState == .Pulling {
                print("下拉刷新")
                refreshView.refreshState = .Normal
            }else if height > RQRefreshOffset && refreshView.refreshState == .Normal {
                refreshView.refreshState = .Pulling
                print("松开刷新")
            }else if height < RQRefreshOffset && refreshView.refreshState == .WilRefresh {
                if sv.contentOffset.y >= -(RQRefreshOffset + topInset) {
                    var inset = sv.contentInset
                    inset.top += height - lastHeight
                    print(inset.top)
                    sv.contentInset = inset
                    lastHeight = height
                }
            }
        }else {
            if refreshView.refreshState == .Pulling {
                beginRefreshing()
                
                sendActions(for: .valueChanged)
            }
        }
        
    }
    
    override public func removeFromSuperview() {
        // scrollView还存在
        scrollView?.removeObserver(self, forKeyPath: "contentOffset")
        
        super.removeFromSuperview()
        
        // scrollView不存在
    }
    
    
    // MARK: - 构造函数
    init() {
        super.init(frame: CGRect())
        
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    
    // MARK: - 懒加载控件
    fileprivate lazy var refreshView = RQRefreshView.refreshView()
}

// MARK: - 设置界面
extension RQRefreshControl {
    
    fileprivate func setupUI() {
        // 设置背景颜色
        backgroundColor = superview?.backgroundColor
        
        // 添加控件
        addSubview(refreshView)
        
        // 设置布局
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1,
                                         constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1,
                                         constant: refreshView.bounds.height))
    }
}
