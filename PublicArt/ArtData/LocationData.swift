//
//  LocationData.swift
//  ArtCity
//
//  Created by Michael Kinney on 1/27/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import Foundation

class LocationData {
	
	let locationName: String
	private var photoFileNames = [String]()
	private var artNameForPhotoFileName = [String:String]()
	
	init(location: Location, fetcher: Fetcher, excludePlaceholderImages:Bool) {
		locationName = location.name
		if let arts = fetcher.fetchArtWithPhotosForLocation(location.idLocation) {
			for art in arts {
				if let photoFileNames = PhotoFileNames(art:art, excludePlaceholderImages: excludePlaceholderImages).names() {
					self.photoFileNames += photoFileNames
					for fileName in photoFileNames {
						artNameForPhotoFileName[fileName] = art.title
					}
				}
			}
		}
	}
	
	func artNameForPhoto(photoIndex: Int) -> String? {
		var name: String?
		if let photoFileName = photoFileName(photoIndex) {
			name = artNameForPhotoFileName[photoFileName]
		}
		return name
	}
	
	func photoCount() -> Int {
		return photoFileNames.count
	}
	
	func photoFileName(photoIndex: Int) -> String? {
		var name: String?
		if photoIndex < photoCount() {
			name = photoFileNames[photoIndex]
		}
		return name
	}
}