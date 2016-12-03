//
//  SingleArtPhotosPresentAnimatedTransistioning.swift
//  ArtCity
//
//  Created by Michael Kinney on 2/2/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import UIKit

class SingleArtPhotosPresentAnimatedTransistioning: NSObject, UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.2 // TODO:
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let animatingViewController:UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
		let animatingView = animatingViewController.view
		animatingView?.frame = transitionContext.finalFrame(for: animatingViewController)
//		animatingView.layer.shadowOpacity = 0.5 // affects toolbar tranparency
//		animatingView.layer.cornerRadius = 5
		animatingView?.clipsToBounds = true
		
		if let animatingView = animatingView {
			transitionContext.containerView.addSubview(animatingView)
        }
		
		let presentedTransform = CGAffineTransform.identity
		let scale = CGAffineTransform(scaleX: 0.001,y: 0.001) // TODO:
	//	var rotation = CGAffineTransformMakeRotation(5 * CGFloat(M_PI)) // TODO:
		let dismissedTransform = scale
		
		animatingView?.transform = dismissedTransform
		
		UIView.animate(withDuration: transitionDuration(using: transitionContext),
			delay: 0,
			options: UIViewAnimationOptions(),
			animations: { () -> Void in
				animatingView?.transform = presentedTransform
			}) { (finished) -> Void in
				transitionContext.completeTransition(finished)
		}
	}
	
}
