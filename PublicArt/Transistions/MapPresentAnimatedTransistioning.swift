//
//  MapPresentAnimatedTransistioning
//  City Art San Francisco
//
//  Created by Michael Kinney on 12/12/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import UIKit

class MapPresentAnimatedTransistioning: NSObject, UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 1.0
	}

func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let animatingViewController:UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        guard let animatingView = animatingViewController.view else {
            return
        }
		animatingView.frame = transitionContext.finalFrame(for: animatingViewController)
		animatingView.layer.shadowOpacity = 0.5 // affects toolbar tranparency
//		animatingView.layer.cornerRadius = 5
//		animatingView.clipsToBounds = true
        transitionContext.containerView.addSubview(animatingView)
	
		let presentedTransform = CGAffineTransform.identity
		let scale = CGAffineTransform(scaleX: 0.001,y: 0.001) 
		let rotation = CGAffineTransform(rotationAngle: 8 * CGFloat(M_PI)) // TODO:
		let dismissedTransform = scale.concatenating(rotation)
		
		animatingView.transform = dismissedTransform
		
		UIView.animate(withDuration: transitionDuration(using: transitionContext),
									delay: 0,
				   usingSpringWithDamping: 300.0, // TODO define
					initialSpringVelocity: 10.0, // TODO define
								  options: [UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.beginFromCurrentState],
							   animations: { () -> Void in
									animatingView.transform = presentedTransform
								}) { (finished) -> Void in
									transitionContext.completeTransition(finished)
								}
	}
}
