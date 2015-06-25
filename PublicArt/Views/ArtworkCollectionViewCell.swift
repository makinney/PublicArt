//
//  ArtworkCollectionViewCell.swift
//  San Francisco Artwork
//
//  Created by Michael Kinney on 11/13/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import UIKit

class ArtworkCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var title: UILabel!
	var imageFileName = String()
		
	@IBOutlet weak var photoBorderView: UIView!
//	var imageSize:CGSize = CGSize(width: 0, height: 0)
	

}
