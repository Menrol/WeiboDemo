//
//  OAuthViewController.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/5/31.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {
    
    fileprivate lazy var webView: UIWebView = UIWebView()
    
    //MARK: - 监听方法
    @objc fileprivate func close(){
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - 自动填充用户名和密码
    @objc fileprivate func autoFill(){
        let jsString = "document.getElementById('userId').value='15029263785';" + "document.getElementById('passwd').value='goalone2O13~';"
        
        webView.stringByEvaluatingJavaScript(from: jsString)
    }
    
    override func loadView() {
        view = webView
        webView.delegate = self
        
        title = "登录新浪微博"
        //设置按钮
        let returnButton = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(OAuthViewController.close))
        navigationItem.leftBarButtonItem = returnButton
        let autofillButton = UIBarButtonItem(title: "自动填充", style: .plain, target: self, action: #selector(OAuthViewController.autoFill))
        navigationItem.rightBarButtonItem = autofillButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //加载页面
        webView.loadRequest(URLRequest(url: NetworkTool.sharedTool.oauthURL))
    }
    
}

//MARK: - UIWebViewDelegate
extension OAuthViewController: UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        guard let host = request.url?.host, host == "www.baidu.com" else {
            return true
        }
        
        guard let query = request.url?.query, query.hasPrefix("code=") else {
            dismiss(animated: true, completion: nil)
            
            return false
        }
        
        let code = query.substring(from: "code=".endIndex)
        print(code)
        
        NetworkTool.sharedTool.getloadAccessToken(code: code) { (result, error) in
            print(result!)
        }
        
        dismiss(animated: true, completion: nil)
        return false
    }
}
