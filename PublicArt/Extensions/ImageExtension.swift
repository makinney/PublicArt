//
//  ImageExtension.swift
//  PublicArt
//
//  Created by Michael Kinney on 11/27/15.
//  Copyright © 2015 makinney. All rights reserved.
//

import UIKit

extension UIImage {
	
	class func imageWithColor(color: UIColor) -> UIImage {
		let rect: CGRect = CGRectMake(0, 0, 1, 1)
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), false, 0)
		color.setFill()
		UIRectFill(rect)
		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
}