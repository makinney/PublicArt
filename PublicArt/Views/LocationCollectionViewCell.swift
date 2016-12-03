//
//  LocationCollectionViewCell
//  San Francisco Artwork
//
//  Created by Michael Kinney on 6/25/2015
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import UIKit

class LocationCollectionViewCell: UICollectionViewCell {
   
	@IBOutlet weak var viewHeight: NSLayoutConstraint!
	@IBOutlet weak var title: UILabel!
	var imageFileName = String()
		
	
	override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
		super.apply(layoutAttributes)
		let attributes = layoutAttributes as! ArtworkLayoutAttributes
		viewHeight.constant = attributes.photoHeight // no images for location collection
	}

	
}
