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
    

    override func loadView() {
        isLogin ? super.loadView() : setVisitorView()
    }

}

//MARK - 设置视图
extension VisitorTableViewController{
    
    fileprivate func setVisitorView(){
        
        visitorView = VisitorView()
        view = visitorView
        
    }
}
