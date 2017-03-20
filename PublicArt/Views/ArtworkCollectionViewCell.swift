//
//  ArtworkCollectionViewCell.swift
//  San Francisco Artwork
//
//  Created by Michael Kinney on 11/13/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import UIKit

class ArtworkCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet weak var imageViewHeight: NSLayoutConstraint!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.shadowRadius = 4.0
            imageView.layer.shadowOpacity = 1
            imageView.layer.shadowOffset = CGSize(width: 3, height: -3)
            imageView.layer.shadowColor = UIColor.black.cgColor
        }
    }
	@IBOutlet weak var title: UILabel!
    
	
	var imageFileName = String()
	
	
	override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
		super.apply(layoutAttributes)
		let attributes = layoutAttributes as! ArtworkLayoutAttributes
		imageViewHeight.constant = attributes.photoHeight
	}
	
	
}
