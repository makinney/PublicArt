//
//  SingleArtSummaryViewController.swift
//  ArtCity
//
//  Created by Michael Kinney on 5/9/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import UIKit

class SingleArtSummaryViewController: UIViewController {

	@IBOutlet weak var artistName: UILabel!
	@IBOutlet weak var artTitle: UILabel!
	@IBOutlet weak var dimensions: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var medium: UILabel!
	
	var art: Art?
	
	private let artPhotoImages = ArtPhotoImages.sharedInstance
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(animated: Bool) {
		if let art = art {
			artTitle.text = art.title
			artistName.text = art.artistName
			medium.text = art.medium
			dimensions.text = art.dimensions
			imageView.image = nil
//			if !art.thumbFile.isEmpty {
//				if let thumbNail = self.artPhotoImages.getThumbNailWith(art.thumbFile, size: imageView.frame.size) {
//					imageView.image = thumbNail.image
//				}
//			}
		}
	}
 }
