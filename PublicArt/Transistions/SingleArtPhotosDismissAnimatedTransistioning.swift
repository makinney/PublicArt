//
//  SingleArtPhotosDismissAnimatedTransistioning.swift
//  ArtCity
//
//  Created by Michael Kinney on 2/2/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import UIKit


class SingleArtPhotosDismissAnimatedTransistioning: NSObject, UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.25 // TODO:
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let fromVC:UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
		//var fromView = fromVC.view
		
		//var toVC:UIViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
		//var toView = toVC.view
		
		//var containerView = transitionContext.containerView()
		
		let animatingVC = fromVC
		let animatingView = animatingVC.view
		animatingView?.frame = transitionContext.finalFrame(for: animatingVC)
		
		let presentedTransform = CGAffineTransform.identity
		let scale = CGAffineTransform(scaleX: 0.01,y: 0.01) // TODO: shrink to this size value
	//	var rotation = CGAffineTransformMakeRotation(17 * CGFloat(M_PI)) // TODO:
	//	var dismissedTransform = CGAffineTransformConcat(scale, rotation)
		let dismissedTransform = scale
		
		animatingView?.transform = presentedTransform
		
		UIView.animate(withDuration: transitionDuration(using: transitionContext),
			delay: 0,
			options: [UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.beginFromCurrentState],
			animations: { () -> Void in
				animatingView?.transform = dismissedTransform
			}) { (finished) -> Void in
				transitionContext.completeTransition(finished)
		}
	}
}
