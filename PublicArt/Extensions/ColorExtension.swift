//
//  ColorExtension.swift
//  PublicArt
//
//  Created by Michael Kinney on 7/15/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
	
	class func selectionBackgroundHighlite() -> UIColor {
		return UIColor(red: 0.06, green: 0.411, blue: 0.60 ,alpha: 1.0)
	}
	
	class func sfOrangeColor() -> UIColor {
		return UIColor(red: 0.972, green: 0.266, blue: 0.1137, alpha: 1.0)
	}
	
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