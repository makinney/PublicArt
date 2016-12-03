//
//  ImageExtension.swift
//  PublicArt
//
//  Created by Michael Kinney on 11/27/15.
//  Copyright © 2015 makinney. All rights reserved.
//

import UIKit

extension UIImage {
	
	class func imageWithColor(_ color: UIColor) -> UIImage {
		let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
		UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
		color.setFill()
		UIRectFill(rect)
		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return image
	}
}
