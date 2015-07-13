//
//  MapPresentationController
//  City Art San Francisco
//
//  Created by Michael Kinney on 12/9/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import UIKit

class MapPresentationController: UIPresentationController {

	var dimmingView: UIView!

	override init(presentedViewController: UIViewController!, presentingViewController: UIViewController!) {
		super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
		setupDimmingView()
	}
	
	func setupDimmingView() {
		dimmingView = UIView()
//		dimmingView.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.1)
		var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
		visualEffectView.frame = dimmingView.bounds
		visualEffectView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
		dimmingView.addSubview(visualEffectView)
		
		let tapRecognizer = UITapGestureRecognizer(target: self, action: "dimmingViewTapped:")
		dimmingView.addGestureRecognizer(tapRecognizer)
	}
	
	func dimmingViewTapped(tapRecognizer: UITapGestureRecognizer) {
		presentingViewController.dismissViewControllerAnimated(true, completion: nil)
	}
	
	
//	override func adaptivePresentationStyle() -> UIModalPresentationStyle{
//	// When we adapt to a compact width environment, we want to be over full screen
//	return UIModalPresentationStyle.OverFullScreen
//	}
//
	
	override func containerViewWillLayoutSubviews() {
		dimmingView.frame = containerView.bounds
		presentedView().frame = frameOfPresentedViewInContainerView()
		
//		presentedView().layer.borderColor = UIColor.lightGrayColor().CGColor
//		presentedView().layer.borderWidth = 2.0
//		presentedView().layer.cornerRadius = 10.0
	}
	
	
	override func frameOfPresentedViewInContainerView() -> CGRect {//
		var containerBounds:CGRect = self.containerView.bounds
		var presentedViewFrame = CGRectZero
		var width:CGFloat = containerBounds.size.width * 0.80
		var height:CGFloat = containerBounds.size.height  * 0.80 // TODO: hard coded
//		if self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.Compact {
//			height = 500
//		} else {
//			height = containerBounds.size.height
//			
//		}
//		
		presentedViewFrame.size = CGSizeMake(width,height)
		presentedViewFrame.origin = CGPointMake(containerBounds.size.width / 2.0, containerBounds.size.height / 2.0) // TODO: can use to locate initial frame postion
		presentedViewFrame.origin.x -= presentedViewFrame.size.width / 2.0; // TODO: can use to locate initial frame postion
		presentedViewFrame.origin.y -= presentedViewFrame.size.height / 2.0; // TODO: can use to locate initial frame postion
		
		return presentedViewFrame
	}

	override func presentationTransitionWillBegin() {
//		super.presentationTransitionWillBegin()
//		configureViews()
		self.dimmingView.alpha = 0.0 // TODO:

		let containerView = self.containerView
		dimmingView.frame = containerView.bounds
		dimmingView.alpha = 0.0
		containerView.insertSubview(dimmingView, atIndex: 0)

		presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (context) -> Void in
			self.dimmingView.alpha = 1.0
		}, completion: nil)
	}
	
	override func dismissalTransitionWillBegin() {
		presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (context) -> Void in
			self.dimmingView.alpha = 0.0
		}, completion: nil)
	}
	
}
