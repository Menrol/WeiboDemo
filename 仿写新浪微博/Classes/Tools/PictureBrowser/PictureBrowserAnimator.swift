//
//  PictureBrowserAnimator.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/8/27.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

protocol PictureBrowserPresentDelegate: NSObjectProtocol {
    func imageViewForAnimation(indexPath: IndexPath) -> UIImageView
    func startPositionForAnimation(indexPath: IndexPath) -> CGRect
    func endPositionForAnimation(indexPath: IndexPath) -> CGRect
}

protocol PictureBrowserDismissDelegate: NSObjectProtocol {
    func imageViewForAnimation() -> UIImageView
    func indexPathForAnimation() -> IndexPath
}

class PictureBrowserAnimator: NSObject, UIViewControllerTransitioningDelegate {
    /// 索引
    var indexPath: IndexPath?
    /// 出现代理
    weak var presentDelegate: PictureBrowserPresentDelegate?
    /// 消失代理
    weak var dismissDelegate: PictureBrowserDismissDelegate?
    /// 动画标记
    fileprivate var isPresent: Bool = false
    
    /// 设置代理参数
    func setParameters(indexPath: IndexPath, presentDelegate: PictureBrowserPresentDelegate, dismissDelegate: PictureBrowserDismissDelegate) {
        self.indexPath = indexPath
        self.presentDelegate = presentDelegate
        self.dismissDelegate = dismissDelegate
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        
        return self
    }
}

extension PictureBrowserAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresent ? presentAnimation(context: transitionContext) : dismissAnimation(context: transitionContext)
    }
    
    private func presentAnimation(context: UIViewControllerContextTransitioning) {
        guard let indexPath = indexPath, let presentDelegate = presentDelegate else {
            return
        }
        
        context.containerView.addSubview(context.view(forKey: .to)!)
        let toController = context.viewController(forKey: .to) as? PictureBrowserViewController
        toController?.collectionView.isHidden = true
        
        let imageView = presentDelegate.imageViewForAnimation(indexPath: indexPath)
        imageView.frame = presentDelegate.startPositionForAnimation(indexPath: indexPath)
        context.containerView.addSubview(imageView)
        
        UIView.animate(withDuration: transitionDuration(using: context), animations: { 
            imageView.frame = presentDelegate.endPositionForAnimation(indexPath: indexPath)
        }) { (_) in
            imageView.removeFromSuperview()
            toController?.collectionView.isHidden = false
            context.completeTransition(true)
        }
    }
    
    private func dismissAnimation(context: UIViewControllerContextTransitioning) {
        guard let presentDelegate = presentDelegate,
            let dismissDelegate = dismissDelegate else {
            return
        }
        
        context.view(forKey: .from)?.removeFromSuperview()
        
        let imageView = dismissDelegate.imageViewForAnimation()
        context.containerView.addSubview(imageView)
        
        UIView.animate(withDuration: transitionDuration(using: context), animations: { 
            imageView.frame = presentDelegate.startPositionForAnimation(indexPath: dismissDelegate.indexPathForAnimation())
        }) { (_) in
            imageView.removeFromSuperview()
            context.completeTransition(true)
        }
    }
}
