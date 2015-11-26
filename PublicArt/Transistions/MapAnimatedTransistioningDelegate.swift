//
//  MapAnimatedTransistioningDelegate.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 12/12/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import UIKit

class MapAnimatedTransistioningDelegate : NSObject, UIViewControllerTransitioningDelegate {
	
	func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
		return MapPresentationController(presentedViewController: presented, presentingViewController: presenting)
	}
	
	func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		let mapPresentAnimatedTransistioning = MapPresentAnimatedTransistioning()
		return mapPresentAnimatedTransistioning
	}
	
	func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		let mapDismissAnimatedTransistioning = MapDismissAnimatedTransistioning()
		return mapDismissAnimatedTransistioning
	}

}