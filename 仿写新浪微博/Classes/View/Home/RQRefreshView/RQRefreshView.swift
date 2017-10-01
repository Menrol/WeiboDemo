//
//  RQRefreshView.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/10/1.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class RQRefreshView: UIView {
    
    @IBOutlet weak var pullImageView: UIImageView!
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var stateLabel: UILabel!
    
    var refreshState:RQRefreshState = .Normal {
        didSet {
            switch refreshState {
            case .Normal:
                stopAnimation()
                
                self.stateLabel.text = "下拉刷新"
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.pullImageView.transform = CGAffineTransform.identity
                })
            case .Pulling:
                stateLabel.text = "释放更新"
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.pullImageView.transform = CGAffineTransform(rotationAngle:CGFloat(Double.pi + 0.0001))
                })
            case .WilRefresh:
                stateLabel.text = "正在刷新"
                
                startAnimation()
            }
        }
    }
    
    private func startAnimation() {
        pullImageView.isHidden = true
        loadingImageView.isHidden = false
        
        let key = "transform.rotation"
        let animation = CABasicAnimation(keyPath: key)
        animation.toValue = Double.pi
        animation.repeatCount = MAXFLOAT
        animation.duration = 0.5
        animation.isRemovedOnCompletion = false
        
        loadingImageView.layer.add(animation, forKey: key)
        
    }
    
    func stopAnimation() {
        self.loadingImageView.layer.removeAllAnimations()
        
        self.loadingImageView.isHidden = true
        self.pullImageView.isHidden = false
    }
    
    class func refreshView() -> RQRefreshView {
        let nib = UINib(nibName: "RQRefreshView", bundle: nil)
        
        return nib.instantiate(withOwner: nil, options: nil)[0] as! RQRefreshView
    }
    
}
