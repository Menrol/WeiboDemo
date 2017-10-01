//
//  DiscoverTableViewController.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/5/20.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class DiscoverTableViewController: VisitorTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        visitorView?.setvisitorView(imageName: "visitordiscover_image_message", message: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过")
    }
}
