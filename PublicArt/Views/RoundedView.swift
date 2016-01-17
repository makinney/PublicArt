//
//  RoundedView.swift
//  PublicArt
//
//  Created by Michael Kinney on 1/15/16.
//  Copyright © 2016 makinney. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView {
	
	@IBInspectable var cornerRadius: CGFloat = 0 {
		didSet {
			layer.cornerRadius = cornerRadius
			layer.masksToBounds = cornerRadius > 0
		}
	}
}
