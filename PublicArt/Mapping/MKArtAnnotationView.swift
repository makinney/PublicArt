//
//  MKArtAnnotationView.swift
//  ArtCity
//
//  Created by Michael Kinney on 2/27/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import Foundation
import MapKit

class MKArtAnnotationView : MKAnnotationView {

	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		if let subtitle = annotation?.subtitle {
			image = UIImage(named: ArtMapPins().imageNameFor(subtitle!))
		} else {
			image = UIImage(named: ArtMapPins().imageNameFor("a")) // any letter's good
		}
	}
	
	func updateImage(){
		if let subtitle = annotation?.subtitle {
			image = UIImage(named: ArtMapPins().imageNameFor(subtitle!))
		} else {
			image = UIImage(named: ArtMapPins().imageNameFor("a")) // any letter's good
		}
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
}
