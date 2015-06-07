//
//  ImageProcess.swift
//  ArtCity
//
//  Created by Michael Kinney on 5/6/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import Foundation
import UIKit

func imageResizeTo (newSize:CGSize, image: UIImage) -> UIImage {
	let hasAlpha = false
	let scale: CGFloat = 0.0 // user screen scale factor
	
	UIGraphicsBeginImageContextWithOptions(newSize, !hasAlpha, scale)
	let rect = CGRect(origin: CGPointZero, size: newSize)
	image.drawInRect(rect)
	
	let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
	UIGraphicsEndImageContext()
	return scaledImage
}