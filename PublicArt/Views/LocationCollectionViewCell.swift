//
//  LocationCollectionViewCell
//  San Francisco Artwork
//
//  Created by Michael Kinney on 6/25/2015
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import UIKit

class LocationCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var title: UILabel!
	var imageFileName = String()
		
	@IBOutlet weak var photoBorderView: UIView!
}