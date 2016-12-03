//
//  MapAnimatedTransistioningDelegate.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 12/12/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import UIKit

class MapAnimatedTransistioningDelegate : NSObject, UIViewControllerTransitioningDelegate {
	
	func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		return MapPresentationController(presentedViewController: presented, presenting: presenting!)
	}
	
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		let mapPresentAnimatedTransistioning = MapPresentAnimatedTransistioning()
		return mapPresentAnimatedTransistioning
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		let mapDismissAnimatedTransistioning = MapDismissAnimatedTransistioning()
		return mapDismissAnimatedTransistioning
	}

}
