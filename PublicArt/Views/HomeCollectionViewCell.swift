//
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
	
    override func awakeFromNib() {
        super.awakeFromNib()
		menuItemName.textColor = UIColor.sfOrangeColor()
        // Initialization code
    }
	
	override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
		super.applyLayoutAttributes(layoutAttributes)
		let attributes = layoutAttributes as! ArtworkLayoutAttributes
		imageViewHeight.constant = attributes.photoHeight
	}

}
