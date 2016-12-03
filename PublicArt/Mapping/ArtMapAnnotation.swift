//
//  ArtMapAnnotation.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 12/29/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//
import Foundation
import UIKit
import MapKit

class ArtMapAnnotation : NSObject {
	var art:Art?
	
	init(art:Art) {
		self.art = art
	}
}

extension ArtMapAnnotation : MKAnnotation {

	var title: String? {
		if let title = art?.title {
//			println("annotation title \(title)")
			// BUG: iOS 8, max 20 (on 4 inch phone) characters or image will shift on callout
			let maxCharacters = 20
			if title.characters.count > maxCharacters {
				let elipses = "..."
				let elipseCount = elipses.characters.count
				let trimmedTitle = title.substring(to: title.characters.index(title.startIndex, offsetBy: (maxCharacters - elipseCount)))
				return trimmedTitle + elipses
			}
			return title
		}
		return ""
	}

	
	var subtitle: String? {
		var subtitle = String()
		if let artist = art?.artist {
			subtitle = artistFullName(artist)
		}
		return subtitle
	}
	
	var coordinate: CLLocationCoordinate2D {
		var coordinates = CLLocationCoordinate2D(latitude: ArtCityMap.centerLatitude , longitude: ArtCityMap.centerLongitude )
		if let art = art {
			let latitude = art.latitude.doubleValue
			let longitude = art.longitude.doubleValue
			coordinates = CLLocationCoordinate2D(latitude:latitude, longitude: longitude)
		}
		return coordinates
	}
}
