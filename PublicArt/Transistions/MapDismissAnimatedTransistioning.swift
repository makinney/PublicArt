//
//  MapDismissAnimatedTransistioning
//  City Art San Francisco
//
//  Created by Michael Kinney on 12/12/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import UIKit


class MapDismissAnimatedTransistioning: NSObject, UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
		return 0.25 // TODO:
	}
	
	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		let fromVC:UIViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
		//var fromView = fromVC.view
		
//		var toVC:UIViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
		//var toView = toVC.view
		
//		var containerView = transitionContext.containerView()
		
		let animatingVC = fromVC
		let animatingView = animatingVC.view
		animatingView.frame = transitionContext.finalFrameForViewController(animatingVC)
		
		let presentedTransform = CGAffineTransformIdentity
		let scale = CGAffineTransformMakeScale(0.01,0.01) // TODO: shrink to this size value
//		var rotation = CGAffineTransformMakeRotation(9 * CGFloat(M_PI)) // TODO:
//		var dismissedTransform = CGAffineTransformConcat(scale, rotation)
		let dismissedTransform = scale
		
		animatingView.transform = presentedTransform
		
		UIView.animateWithDuration(transitionDuration(transitionContext),
			delay: 0,
			options: [UIViewAnimationOptions.AllowUserInteraction, UIViewAnimationOptions.BeginFromCurrentState],
			animations: { () -> Void in
				animatingView.transform = dismissedTransform
			}) { (finished) -> Void in
				transitionContext.completeTransition(finished)
		}
	}
}