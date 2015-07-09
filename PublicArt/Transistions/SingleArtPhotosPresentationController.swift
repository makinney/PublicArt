//
//  SingleArtPhotosPresentationController.swift
//  ArtCity
//
//  Created by Michael Kinney on 2/2/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import UIKit

class SingleArtPhotosPresentationController: UIPresentationController {

	var dimmingView: UIView!
	var closeButton: UIButton?
	
	override init(presentedViewController: UIViewController!, presentingViewController: UIViewController!) {
		super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
		setupDimmingView()
	}
	
	func setupDimmingView() {
		dimmingView = UIView()
		var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
		visualEffectView.frame = dimmingView.bounds
		visualEffectView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
		dimmingView.addSubview(visualEffectView)
		
		let tapRecognizer = UITapGestureRecognizer(target: self, action: "dimmingViewTapped:")
		dimmingView.addGestureRecognizer(tapRecognizer)
	}
	
	func setupCloseButton() {
		closeButton?.removeFromSuperview()
		closeButton = (UIButton.buttonWithType(.Custom)  as! UIButton)
		closeButton?.addTarget(self, action: "closeButtonTapped:", forControlEvents: UIControlEvents.AllTouchEvents)

		let image = UIImage(named: "photo-doneButton") ?? UIImage()
		closeButton?.setImage(image, forState: .Normal)
		
		let buttonWidth: CGFloat? = closeButton?.currentImage?.size.width ?? 44
		let buttonHeight: CGFloat? = 44 // closeButton?.currentImage?.size.height
		var presentationView = presentedView()
		var originX = presentationView.frame.size.width - buttonWidth! - 8.0
		var originY: CGFloat
		if dimmingView.traitCollection.verticalSizeClass == .Compact {
			originY = presentationView.frame.origin.y
		} else {
			originY = presentationView.frame.origin.y  + 20
		}
		
		var origin = CGPoint(x: originX, y: originY)
		var size = CGSize(width: buttonWidth!, height: buttonHeight!)
		var frame = CGRect(origin: origin, size: size)
		closeButton?.frame = frame
		presentedView().addSubview(closeButton!)

	}
	
	func dimmingViewTapped(tapRecognizer: UITapGestureRecognizer) {
		dismiss()
	}
	
	func closeButtonTapped(sender: UIButton) {
		dismiss()
	}
	
	func dismiss() {
		presentingViewController.dismissViewControllerAnimated(true, completion: nil)
	}
	
	override func containerViewWillLayoutSubviews() {
		dimmingView.frame = containerView.bounds
		presentedView().frame = frameOfPresentedViewInContainerView()
		setupCloseButton()
	}
	
	override func frameOfPresentedViewInContainerView() -> CGRect {//
		var containerBounds:CGRect = self.containerView.bounds
		var presentedViewFrame = CGRectZero
		var width:CGFloat = containerBounds.size.width * 1.0
		var height:CGFloat = containerBounds.size.height  * 1.0 // TODO: hard coded

		presentedViewFrame.size = CGSizeMake(width,height)
		presentedViewFrame.origin = CGPointMake(containerBounds.size.width / 2.0, containerBounds.size.height / 2.0) // TODO: can use to locate initial frame postion
		presentedViewFrame.origin.x -= presentedViewFrame.size.width / 2.0; // TODO: can use to locate initial frame postion
		presentedViewFrame.origin.y -= presentedViewFrame.size.height / 2.0; // TODO: can use to locate initial frame postion
		return presentedViewFrame
	}

	override func presentationTransitionWillBegin() {
//		super.presentationTransitionWillBegin()
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

