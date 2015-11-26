//
//  MapPresentAnimatedTransistioning
//  City Art San Francisco
//
//  Created by Michael Kinney on 12/12/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import UIKit

class MapPresentAnimatedTransistioning: NSObject, UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
		return 1.0 // TODO:
	}

func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		let animatingViewController:UIViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
		let animatingView = animatingViewController.view
		animatingView.frame = transitionContext.finalFrameForViewController(animatingViewController)
		animatingView.layer.shadowOpacity = 0.5 // affects toolbar tranparency
//		animatingView.layer.cornerRadius = 5
//		animatingView.clipsToBounds = true

		if let containerView = transitionContext.containerView() {
			containerView.addSubview(animatingView)
		}
	
		let presentedTransform = CGAffineTransformIdentity
		let scale = CGAffineTransformMakeScale(0.001,0.001) // TODO:
		let rotation = CGAffineTransformMakeRotation(8 * CGFloat(M_PI)) // TODO:
		let dismissedTransform = CGAffineTransformConcat(scale, rotation)
		
		animatingView.transform = dismissedTransform
		
		UIView.animateWithDuration(transitionDuration(transitionContext),
									delay: 0,
				   usingSpringWithDamping: 300.0, // TODO define
					initialSpringVelocity: 10.0, // TODO define
								  options: [UIViewAnimationOptions.AllowUserInteraction, UIViewAnimationOptions.BeginFromCurrentState],
							   animations: { () -> Void in
									animatingView.transform = presentedTransform
								}) { (finished) -> Void in
									transitionContext.completeTransition(finished)
								}
	}

}