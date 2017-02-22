//
//  SingleArtPhotosAnimatedTransistioningDelegate.swift
//  ArtCity
//
//  Created by Michael Kinney on 2/2/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import UIKit

class SingleArtPhotosAnimatedTransistioningDelegate : NSObject, UIViewControllerTransitioningDelegate {
	
	func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		return SingleArtPhotosPresentationController(presentedViewController: presented, presenting: presenting)
	}
	
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		let mapPresentAnimatedTransistioning = SingleArtPhotosPresentAnimatedTransistioning()
		return mapPresentAnimatedTransistioning
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		let mapDismissAnimatedTransistioning = SingleArtPhotosDismissAnimatedTransistioning()
		return mapDismissAnimatedTransistioning
	}
	
}
