//
//  SingleArtPhotosAnimatedTransistioningDelegate.swift
//  ArtCity
//
//  Created by Michael Kinney on 2/2/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import UIKit

class SingleArtPhotosAnimatedTransistioningDelegate : NSObject, UIViewControllerTransitioningDelegate {
	
	func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
		return SingleArtPhotosPresentationController(presentedViewController: presented, presentingViewController: presenting)
	}
	
	func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		let mapPresentAnimatedTransistioning = SingleArtPhotosPresentAnimatedTransistioning()
		return mapPresentAnimatedTransistioning
	}
	
	func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		let mapDismissAnimatedTransistioning = SingleArtPhotosDismissAnimatedTransistioning()
		return mapDismissAnimatedTransistioning
	}
	
}