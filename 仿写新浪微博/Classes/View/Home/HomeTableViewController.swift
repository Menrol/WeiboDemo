//
//  HomeTableViewController.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/5/20.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 原创微博可重用Cell
let StatusNormalCellId = "StatusNormalCellId"
/// 转发微博可重用Cell
let StatusRetweetCellId = "StatusRetweetCellId"

class HomeTableViewController: VisitorTableViewController {
    
    fileprivate lazy var statusListViewModel: StatusListViewModel = StatusListViewModel()

    // MARK: - 控制器生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UserAccountViewModel.sharedUersAccount.isLogin {
            visitorView?.setvisitorView(imageName: nil, message: "登录后，你所关注的人的微博会显示在这里")
            
            return
        }
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        setupTableView()
        
        loadData(isPulldown: true)
        
        // 注册通知
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: WBStatusSelectedPcitureNotification), object: nil, queue: nil) { [weak self] (n) in
            guard let urls = n.userInfo?[WBStatusSelectedPictureUrlsKey] as? [URL] else {
                return
            }
            guard let indexPath = n.userInfo?[WBStatusSelectedPictureIndexPathKey] as? IndexPath else {
                return
            }
            guard let cell = n.object as? PictureBrowserPresentDelegate else {
                return
            }
            
            let vc = PictureBrowserViewController(indexPath: indexPath, thumbnailUrls: urls)
            // 设置转场动画模式
            vc.modalPresentationStyle = .custom
            // 设置转场动画代理
            vc.transitioningDelegate = self?.pictureBrowserAnimator
            // 设置代理参数
            self?.pictureBrowserAnimator.setParameters(indexPath: indexPath, presentDelegate: cell, dismissDelegate: vc)
            
            self?.present(vc, animated: true, completion: nil)
        }
    }
    
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 设置tableview
    private func setupTableView() {
        tableView.register(StatusRetweetCell.self, forCellReuseIdentifier: StatusRetweetCellId)
        tableView.register(StatusNormalCell.self, forCellReuseIdentifier: StatusNormalCellId)
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
        
        // 自动计算行高 - 需要一个自上而下的自动布局的控件，指定一个向下的约束
        tableView.estimatedRowHeight = 400
        
        // 设置下拉刷新控件
        tableView.addSubview(myRefreshControl)
        // 添加事件
        myRefreshControl.addTarget(self, action: #selector(HomeTableViewController.loadData), for: .valueChanged)
        // 设置上拉刷新控件
        tableView.tableFooterView = pullUpView
    }
    
    // MARK: - 加载数据
    @objc func loadData(isPulldown: Bool){
        
        if isPulldown {
            // 开始下拉刷新
            myRefreshControl.beginRefreshing()
        }
        
        statusListViewModel.loadData(ispullUp: pullUpView.isAnimating) { (isSuccess) in

            // 结束下拉刷新
            self.myRefreshControl.endRefreshing()

            // 展示下拉刷新提示
            self.showPullUpMessage()

            if !isPulldown {
                // 结束上拉刷新
                self.pullUpView.stopAnimating()
            }

            if !isSuccess {
                SVProgressHUD.showInfo(withStatus: "网络不给力")

                return
            }
            
            // 设置未读个数
            self.tabBarController?.tabBar.items?[0].badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0

            self.tableView.reloadData()
        }
    }
    
    /// 显示下拉刷新提示
    private func showPullUpMessage() {
        // 判断是否是下拉刷新
        guard let count = statusListViewModel.pullDownCount else {
            return
        }
        
        let message = count > 0 ? "更新了\(count)条微博" : "没有新微博"
        let height: CGFloat = 44
        pullDownTipView.text = message
        let rect = CGRect(x: 0, y: 20, width: view.bounds.width, height: height)
        pullDownTipView.frame = rect
        pullDownTipView.isHidden = false
        
        // 设置动画
        UIView.animate(withDuration: 1, animations: {
            self.pullDownTipView.frame = rect.offsetBy(dx: 0, dy: height)
        }) { (_) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                UIView.animate(withDuration: 1, animations: {
                    self.pullDownTipView.frame = rect.offsetBy(dx: 0, dy: -height)
                }, completion: { (_) in
                    self.pullDownTipView.isHidden = true
                })
            })
        }
        
    }
    
    // MARK: - 懒加载控件
    fileprivate lazy var pullUpView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        indicatorView.color = UIColor.lightGray
        
        return indicatorView
    }()
    private lazy var pictureBrowserAnimator: PictureBrowserAnimator = PictureBrowserAnimator()
    private lazy var pullDownTipView: UILabel = {
        let label = UILabel(text: "", font: 18, textColor: UIColor.white)
        label.backgroundColor = UIColor.orange
        label.alpha = 0.8
        
        // 添加到navigationbar下面
        self.navigationController?.view.insertSubview(label, belowSubview: (self.navigationController?.navigationBar)!)
        
        return label
    }()
    private lazy var myRefreshControl = RQRefreshControl()
}


// MARK: - TableViewDataSource
extension HomeTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusListViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = statusListViewModel.statusList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellID, for: indexPath) as! StatusCell
        
        cell.viewModel = viewModel
        
        if indexPath.row == statusListViewModel.statusList.count - 1 && !pullUpView.isAnimating{
            // 开启动画
            pullUpView.startAnimating()
            
            // 刷新数据
            loadData(isPulldown: false)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return statusListViewModel.statusList[indexPath.row].rowHeight
    }
}
