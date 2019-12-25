//
//  SecVC.swift
//  DevTool
//
//  Created by lx on 2019/12/25.
//  Copyright © 2019 lx. All rights reserved.
//

import UIKit

class SecVC: UIViewController {
    
    private var animateType: AnimateType = .vertical
    
    class func loadNibVC(type: AnimateType = .vertical) -> SecVC {
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "SecVC") as! SecVC
        vc.animateType = type
//        vc.view.backgroundColor = UIColor.clear
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.backgroundColor = .white
        self.transitioningDelegate = self
//        self.modalPresentationStyle = .overCurrentContext
    }
    
    @IBAction func goback(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: UIViewControllerTransitioningDelegate
extension SecVC: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return XTransitionAnimator(transitionType: .present, animateType: animateType, duration: 0.5)
//        return XTransitionAnimator(transitionType: .present, maskView: maskBtn, contentView: contentView)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return XTransitionAnimator(transitionType: .dismiss, animateType: animateType, duration: 0.5)
//        return XTransitionAnimator(transitionType: .dismiss, maskView: maskBtn, contentView: contentView)
    }
}
