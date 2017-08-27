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
        
        setupTableView()
        
        loadData()
        
        // 注册通知
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: WBStatusSelectedPcitureNotification), object: nil, queue: nil) { [weak self] (n) in
            guard let urls = n.userInfo?[WBStatusSelectedPictureUrlsKey] as? [URL] else {
                return
            }
            guard let indexPath = n.userInfo?[WBStatusSelectedPictureIndexPathKey] as? IndexPath else {
                return
            }
            
            let vc = PictureBrowserViewController(indexPath: indexPath, thumbnailUrls: urls)
            // 设置转场动画模式
            vc.modalPresentationStyle = .custom
            // 设置转场动画代理
            vc.transitioningDelegate = self?.pictureBrowserAnimator
            
            self?.present(vc, animated: true, completion: nil)
        }
    }
    
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 设置tableview
    private func setupTableView(){
        tableView.register(StatusRetweetCell.self, forCellReuseIdentifier: StatusRetweetCellId)
        tableView.register(StatusNormalCell.self, forCellReuseIdentifier: StatusNormalCellId)
        tableView.separatorStyle = .none
        
        // 自动计算行高 - 需要一个自上而下的自动布局的控件，指定一个向下的约束
        tableView.estimatedRowHeight = 400
        
        // 设置下拉刷新控件
        refreshControl = WBRefreshControl()
        // 添加事件
        refreshControl?.addTarget(self, action: #selector(HomeTableViewController.loadData), for: .valueChanged)
        
        // 设置上拉刷新控件
        tableView.tableFooterView = pullUpView
    }
    
    // MARK: - 加载数据
    @objc fileprivate func loadData(){
        
        // 开始下拉刷新
        refreshControl?.beginRefreshing()
        
        statusListViewModel.loadData(ispullUp: pullUpView.isAnimating) { (isSuccess) in
            
            // 结束下拉刷新
            self.refreshControl?.endRefreshing()
            
            // 结束上拉刷新
            self.pullUpView.stopAnimating()
            
            if !isSuccess {
                SVProgressHUD.showInfo(withStatus: "网络不给力")
                
                return 
            }
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - 懒加载控件
    fileprivate lazy var pullUpView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        indicatorView.color = UIColor.lightGray
        
        return indicatorView
    }()
    private lazy var pictureBrowserAnimator: PictureBrowserAnimator = PictureBrowserAnimator()
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
            loadData()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return statusListViewModel.statusList[indexPath.row].rowHeight
    }
}
