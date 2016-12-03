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
	
	override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
		super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
		
		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SingleArtPhotosPresentationController.viewTapped(_:)))
		presentedViewController.view.addGestureRecognizer(tapRecognizer)
		
		
		let dblLapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SingleArtPhotosPresentationController.dblViewTapped(_:)))
		dblLapRecognizer.numberOfTapsRequired = 2
		presentedViewController.view.addGestureRecognizer(dblLapRecognizer)
		


		setupDimmingView()
	}
	
	
	func dblViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
	}
	
	func setupDimmingView() {
		dimmingView = UIView()
		let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark)) as UIVisualEffectView
		visualEffectView.frame = dimmingView.bounds
		visualEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		dimmingView.addSubview(visualEffectView)
	}
	
//	func setupCloseButton() {
//		closeButton?.removeFromSuperview()
//		closeButton = (UIButton.buttonWithType(.Custom)  as! UIButton)
//		closeButton?.addTarget(self, action: "closeButtonTapped:", forControlEvents: UIControlEvents.AllTouchEvents)
//
//		let image = UIImage(named: "photo-doneButton") ?? UIImage()
//		closeButton?.setImage(image, forState: .Normal)
//		
//		let buttonWidth: CGFloat? = closeButton?.currentImage?.size.width ?? 44
//		let buttonHeight: CGFloat? = 44 // closeButton?.currentImage?.size.height
//		var presentationView = presentedView()
//		var originX = presentationView.frame.size.width - buttonWidth! - 8.0
//		var originY: CGFloat
//		if dimmingView.traitCollection.verticalSizeClass == .Compact {
//			originY = presentationView.frame.origin.y
//		} else {
//			originY = presentationView.frame.origin.y  + 20
//		}
//		
//		var origin = CGPoint(x: originX, y: originY)
//		var size = CGSize(width: buttonWidth!, height: buttonHeight!)
//		var frame = CGRect(origin: origin, size: size)
//		closeButton?.frame = frame
//		presentedView().addSubview(closeButton!)
//
//	}
	
	func viewTapped(_ tapRecognizer: UITapGestureRecognizer) {
		dismiss()
	}
	
	func closeButtonTapped(_ sender: UIButton) {
		dismiss()
	}
	
	func dismiss() {
		presentingViewController.dismiss(animated: true, completion: nil)
	}
	
	override func containerViewWillLayoutSubviews() {
		if let containerView = containerView {
			dimmingView.frame = containerView.bounds
		}
// TODO: Swift 2.0 what is this form ?		dimmingView.frame = (containerView?.bounds)!
		presentedView?.frame = frameOfPresentedViewInContainerView
//		setupCloseButton()
	}
	
	override var frameOfPresentedViewInContainerView : CGRect {//
		let containerBounds:CGRect = self.containerView?.bounds ?? CGRect()
		var presentedViewFrame = CGRect.zero
		let width:CGFloat = containerBounds.size.width * 1.0
		let height:CGFloat = containerBounds.size.height  * 1.0 // TODO: hard coded

		presentedViewFrame.size = CGSize(width: width,height: height)
		presentedViewFrame.origin = CGPoint(x: containerBounds.size.width / 2.0, y: containerBounds.size.height / 2.0) // TODO: can use to locate initial frame postion
		presentedViewFrame.origin.x -= presentedViewFrame.size.width / 2.0; // TODO: can use to locate initial frame postion
		presentedViewFrame.origin.y -= presentedViewFrame.size.height / 2.0; // TODO: can use to locate initial frame postion
		return presentedViewFrame
	}

	override func presentationTransitionWillBegin() {
//		super.presentationTransitionWillBegin()
		self.dimmingView.alpha = 0.0 // TODO:

		let containerView = self.containerView
		dimmingView.frame = containerView?.bounds ?? CGRect()
		dimmingView.alpha = 0.0
		containerView?.insertSubview(dimmingView, at: 0)

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

