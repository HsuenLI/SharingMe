//
//  CustomAnimationPresentor.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/2/27.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class CustomAnimationPresentor : NSObject, UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        //To camera view
        guard let toView = transitionContext.view(forKey: .to) else {return}
        guard let fromView = transitionContext.view(forKey: .from) else {return}
        containerView.addSubview(toView)
        
        let staringFrame = CGRect(x: -toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
        toView.frame = staringFrame

        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)

            fromView.frame = CGRect(x: fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    
    
}
