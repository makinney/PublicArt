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

	override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
		super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
		setupDimmingView()
	}
	
	func setupDimmingView() {
		dimmingView = UIView()
//		dimmingView.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.1)
		let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark)) as UIVisualEffectView
		visualEffectView.frame = dimmingView.bounds
		visualEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		dimmingView.addSubview(visualEffectView)
		
		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapPresentationController.dimmingViewTapped(_:)))
		dimmingView.addGestureRecognizer(tapRecognizer)
	}
	
	func dimmingViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
		presentingViewController.dismiss(animated: true, completion: nil)
	}
	
	
//	override func adaptivePresentationStyle() -> UIModalPresentationStyle{
//	// When we adapt to a compact width environment, we want to be over full screen
//	return UIModalPresentationStyle.OverFullScreen
//	}
//
	
	override func containerViewWillLayoutSubviews() {
	
		dimmingView.frame = containerView?.bounds ?? CGRect()
		presentedView!.frame = frameOfPresentedViewInContainerView
		
//		presentedView().layer.borderColor = UIColor.lightGrayColor().CGColor
//		presentedView().layer.borderWidth = 2.0
//		presentedView().layer.cornerRadius = 10.0
	}
	
	
	override var frameOfPresentedViewInContainerView : CGRect {//
		let containerBounds:CGRect = self.containerView!.bounds
		var presentedViewFrame = CGRect.zero
		let width:CGFloat = containerBounds.size.width * 0.80
		let height:CGFloat = containerBounds.size.height  * 0.80 // TODO: hard coded
//		if self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.Compact {
//			height = 500
//		} else {
//			height = containerBounds.size.height
//			
//		}
//		
		presentedViewFrame.size = CGSize(width: width,height: height)
		presentedViewFrame.origin = CGPoint(x: containerBounds.size.width / 2.0, y: containerBounds.size.height / 2.0) // TODO: can use to locate initial frame postion
		presentedViewFrame.origin.x -= presentedViewFrame.size.width / 2.0; // TODO: can use to locate initial frame postion
		presentedViewFrame.origin.y -= presentedViewFrame.size.height / 2.0; // TODO: can use to locate initial frame postion
		
		return presentedViewFrame
	}

	override func presentationTransitionWillBegin() {
//		super.presentationTransitionWillBegin()
//		configureViews()
		self.dimmingView.alpha = 0.0 // TODO:

		let containerView = self.containerView
		dimmingView.frame = containerView!.bounds
		dimmingView.alpha = 0.0
		containerView!.insertSubview(dimmingView, at: 0)

		presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) -> Void in
			self.dimmingView.alpha = 1.0
		}, completion: nil)
	}
	
	override func dismissalTransitionWillBegin() {
		presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) -> Void in
			self.dimmingView.alpha = 0.0
		}, completion: nil)
	}
	
}
