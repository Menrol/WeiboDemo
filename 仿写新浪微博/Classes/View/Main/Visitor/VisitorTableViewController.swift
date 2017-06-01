//
//  VisitorTableViewController.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/5/22.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class VisitorTableViewController: UITableViewController {
    
    private var isLogin = false
    
    var visitorView: VisitorView?
    
    //MARK: - 监听方法
    @objc fileprivate func pressloginButton(){
        let oauthViewController = OAuthViewController()
        let nav = UINavigationController(rootViewController: oauthViewController)
        
        present(nav, animated: true, completion: nil)
        
    }
    
    @objc fileprivate func pressregisterButton(){
        print("注册")
    }

    override func loadView() {
        isLogin ? super.loadView() : setVisitorView()
    }

}

//MARK: - 设置界面
extension VisitorTableViewController{
    
    fileprivate func setVisitorView(){
        
        visitorView = VisitorView()
        view = visitorView
        
        //设置导航栏按钮
        let loginButton = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(VisitorTableViewController.pressloginButton))
        navigationItem.leftBarButtonItem = loginButton
        let regsiterButton = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(VisitorTableViewController.pressregisterButton))
        navigationItem.rightBarButtonItem = regsiterButton
        
        //添加按钮监听方法
        visitorView?.loginButton.addTarget(self, action: #selector(VisitorTableViewController.pressloginButton), for: .touchUpInside)
        visitorView?.registerButton.addTarget(self, action: #selector(VisitorTableViewController.pressregisterButton), for: .touchUpInside)
    }
}
