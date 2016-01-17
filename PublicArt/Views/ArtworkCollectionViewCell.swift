//
//  ArtworkCollectionViewCell.swift
//  San Francisco Artwork
//
//  Created by Michael Kinney on 11/13/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import UIKit

class ArtworkCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet weak var titleHeight: NSLayoutConstraint!
	@IBOutlet weak var imageViewHeight: NSLayoutConstraint!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var title: UILabel!
	var imageFileName = String()
	
	
	override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
		super.applyLayoutAttributes(layoutAttributes)
		let attributes = layoutAttributes as! ArtworkLayoutAttributes
		imageViewHeight.constant = attributes.photoHeight
	}
	
	
}
