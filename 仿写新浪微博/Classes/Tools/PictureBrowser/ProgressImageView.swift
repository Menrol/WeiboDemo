//
//  ProgressImageView.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/8/27.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class ProgressImageView: UIImageView {
    
    var progress: CGFloat = 0 {
        didSet{
            progressView.progress = progress
        }
    }
    
    // MARK: - 构造函数
    init() {
        super.init(frame: CGRect.zero)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载控件
    private lazy var progressView: ProgressView = ProgressView()
    
    // MARK: - 设置界面
    private func setupUI() {
        // 添加控件
        addSubview(progressView)
        
        // 设置背景颜色
        progressView.backgroundColor = UIColor.clear
        
        // 设置布局
        progressView.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
    }

}

private class ProgressView: UIView {
    
    var progress: CGFloat = 0 {
        didSet{
            // 重绘视图
            setNeedsDisplay()
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = rect.width * 0.5
        let start = CGFloat(-Double.pi / 2)
        let end = start + progress * 2 * CGFloat(Double.pi)
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        
        path.addLine(to: center)
        path.close()
        
        UIColor.white.setFill()
        
        
        path.fill()
    }
}
