//
//  CustomAnimationDismisser.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/2/27.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class CustomAnimationDismisser : NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: .from) else {return}
        guard let toView = transitionContext.view(forKey: .to) else {return}
        
        containerView.addSubview(toView)
        let endingFrame = CGRect(x: -fromView.frame.width, y: fromView.frame.height, width: fromView.frame.width, height: fromView.frame.height)
        fromView.frame = endingFrame
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            fromView.frame = CGRect(x: -fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
            
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
