//
//  MessageTableViewController.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/5/20.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class MessageTableViewController: VisitorTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        visitorView?.setvisitorView(imageName: "visitordiscover_image_message", message: "登录后，别人评论你的微博，给你发消息，都会在这里收到通知")
    }

}
