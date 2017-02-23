////
//  HomeCollectionViewCell.swift
//  PublicArt
//
//  Created by Michael Kinney on 6/5/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var menuItemNameHeight: NSLayoutConstraint!
	@IBOutlet weak var imageViewHeight: NSLayoutConstraint!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var menuItemName: UILabel!
	@IBOutlet weak var overlayView: UIView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		menuItemName.textColor = UIColor.black
//		let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
		
	//	let visualEffectView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: UIBlurEffect(style: .Dark))) as UIVisualEffectView
		
	//	visualEffectView.frame = imageView.bounds
	//	imageView.addSubview(visualEffectView)
        // Initialization code
    }
	
	override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
		super.apply(layoutAttributes)
		let attributes = layoutAttributes as! ArtworkLayoutAttributes
		imageViewHeight.constant = attributes.photoHeight
	}

}
