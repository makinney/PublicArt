//
//  SingleArtPhotosPresentAnimatedTransistioning.swift
//  ArtCity
//
//  Created by Michael Kinney on 2/2/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import UIKit

class SingleArtPhotosPresentAnimatedTransistioning: NSObject, UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
		return 0.2 // TODO:
	}
	
	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		let animatingViewController:UIViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
		let animatingView = animatingViewController.view
		animatingView.frame = transitionContext.finalFrameForViewController(animatingViewController)
//		animatingView.layer.shadowOpacity = 0.5 // affects toolbar tranparency
//		animatingView.layer.cornerRadius = 5
		animatingView.clipsToBounds = true
		
		if let containerView = transitionContext.containerView() {
			containerView.addSubview(animatingView)
		}
		
		let presentedTransform = CGAffineTransformIdentity
		let scale = CGAffineTransformMakeScale(0.001,0.001) // TODO:
	//	var rotation = CGAffineTransformMakeRotation(5 * CGFloat(M_PI)) // TODO:
		let dismissedTransform = scale
		
		animatingView.transform = dismissedTransform
		
		UIView.animateWithDuration(transitionDuration(transitionContext),
			delay: 0,
			options: UIViewAnimationOptions.CurveEaseInOut,
			animations: { () -> Void in
				animatingView.transform = presentedTransform
			}) { (finished) -> Void in
				transitionContext.completeTransition(finished)
		}
	}
	
}