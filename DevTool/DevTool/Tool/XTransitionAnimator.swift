//
//  XTransitionAnimator.swift
//  Growdex
//
//  Created by lx on 2019/11/2.
//  Copyright © 2019 lx. All rights reserved.
//

import UIKit

enum AnimateType {
    case none       //无动画
    case vertical   //竖向
    case horizontal //横向
    case fade       //渐变
}

class XTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    enum TransitionType {
        case present
        case dismiss
    }
    
    private var transitionType: TransitionType?
    private var animateType: AnimateType = .none
    private var duration: TimeInterval = 0.3
    //针对弹框
    private var maskView: UIView?
    private var contentView: UIView?
    
    init(transitionType: TransitionType, maskView: UIView, contentView: UIView) {
        super.init()
        self.transitionType = transitionType
        self.maskView = maskView
        self.contentView = contentView
    }
    
    init(transitionType: TransitionType, animateType: AnimateType = .horizontal, duration: TimeInterval = 0.3) {
        super.init()
        self.transitionType = transitionType
        self.animateType = animateType
        self.duration = duration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return (animateType == .none) ? 0 : duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch transitionType {
        case .present:
            if maskView != nil, contentView != nil {
                animatePresentViewTransition(using: transitionContext)
            } else {
                animatePresentTransition(using: transitionContext)
            }
        case .dismiss:
            if maskView != nil, contentView != nil {
                animateDismissViewTransition(using: transitionContext)
            } else {
                animateDismissTransition(using: transitionContext)
            }
        default:
            break
        }
    }
    
    // MARK: - Private Method
    // MARK: 针对模态
    private func animatePresentTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let _ = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else { return }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        let duration = self.transitionDuration(using: transitionContext)

        // 通知view更新布局(使autolayout值生效)
        toVC.view.layoutIfNeeded()
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        if animateType == .none {
            toVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        } else if animateType == .vertical {
            toVC.view.frame = CGRect(x: 0, y: height, width: width, height: height)
            UIView.animate(withDuration: duration, animations: {
                toVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
            }) { (isFinish) in
                let isComplete = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(isComplete)
            }
        } else if animateType == .horizontal {
            toVC.view.frame = CGRect(x: width, y: 0, width: width, height: height)
            UIView.animate(withDuration: duration, animations: {
                toVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
            }) { (isFinish) in
                let isComplete = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(isComplete)
            }
        } else if animateType == .fade {
            toVC.view.alpha = 0
            UIView.animate(withDuration: duration, animations: {
                toVC.view.alpha = 1
            }) { (isFinish) in
                let isComplete = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(isComplete)
            }
        }
    }
    
    private func animateDismissTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else { return }
        
        let containerView = transitionContext.containerView
        let duration = self.transitionDuration(using: transitionContext)
        
        var toView: UIView?
        var fromView: UIView?
        
        if transitionContext.responds(to: #selector(value(forKey:))) {
            toView = transitionContext.view(forKey: .to)
            fromView = transitionContext.view(forKey: .from)
        } else {
            toView = toVC.view
            fromView = fromVC.view
        }
        
        guard toView != nil, fromView != nil else {
            return
        }
        
        containerView.insertSubview(toView!, belowSubview: fromView!)
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        if animateType == .none {
            fromVC.view.frame = CGRect(x: width, y: 0, width: width, height: height)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        } else if animateType == .vertical {
            UIView.animate(withDuration: duration, animations: {
                fromVC.view.frame = CGRect(x: 0, y: height, width: width, height: height)
            }) { (isFinish) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        } else if animateType == .horizontal {
            UIView.animate(withDuration: duration, animations: {
                fromView?.frame = CGRect(x: width, y: 0, width: width, height: height)
            }) { (isFinish) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        } else if animateType == .fade {
            fromVC.view.alpha = 1
            UIView.animate(withDuration: duration, animations: {
                fromVC.view.alpha = 0
            }) { (isFinish) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
    
    // MARK: 针对弹框
    private func animatePresentViewTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let _ = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else { return }

        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        let duration = self .transitionDuration(using: transitionContext)
        let maskBtnOriginalAlpha = self.maskView?.alpha

        maskView?.alpha = 0.0
        // 通知view更新布局(使autolayout值生效)
        toVC.view.layoutIfNeeded()
        self.contentView?.origin = CGPoint(x: 0, y: containerView.height)
        UIView.animate(withDuration: duration, animations: {
            self.maskView?.alpha = maskBtnOriginalAlpha ?? 1
            self.contentView?.origin = CGPoint(x: 0, y: (containerView.height - self.contentView!.height))
        }) { (isFinish) in
            let isComplete = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(isComplete)
        }
    }

    private func animateDismissViewTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let _ = transitionContext.viewController(forKey: .to)
            else { return }

        let containerView = transitionContext.containerView
        let duration = self.transitionDuration(using: transitionContext)

        containerView.addSubview(fromVC.view)
        UIView.animate(withDuration: duration, animations: {
            self.maskView?.alpha = 0.0
            self.contentView?.origin = CGPoint(x: 0, y: containerView.height + self.contentView!.height)
        }) { (isFinish) in
            let isComplete = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(isComplete)
        }
    }
}
