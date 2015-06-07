//
//  ArtPhotosByLocation.swift
//  ArtCity
//
//  Created by Michael Kinney on 1/27/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import Foundation
import UIKit

class ArtPhotosByLocation {
	
	private var locationData: [LocationData] = []
	let artPhotoImages = ArtPhotoImages.sharedInstance
	
	init(fetcher: Fetcher) {
		if let locations = fetcher.fetchAllLocations() {
			createLocationData(locations, fetcher: fetcher)
		}
	}
	
	func reload(fetcher: Fetcher) {
		locationData.removeAll(keepCapacity: true)
		if let locations = fetcher.fetchAllLocations() {
			createLocationData(locations, fetcher: fetcher)
		}
	}
	
	private func createLocationData(locations: [Location], fetcher: Fetcher) {
		for location in locations {
			var locationData = LocationData(location: location, fetcher: fetcher, excludePlaceholderImages: true)
			if locationData.photoCount() > 0 {
				self.locationData.append(locationData)
			}
		}
	}
	
	var locationsCount: Int {
		get {
			return locationData.count
		}
	}
	
	
	func photosCount(locationIndex: Int) -> Int {
		if let locationData = locationData(locationIndex) {
			return locationData.photoCount()
		}
		return 0
	}
	
	func photoImage(locationIndex: Int, photoIndex: Int, completion:(image: UIImage?) -> ()) {
		var image: UIImage?
		if let locationData = locationData(locationIndex) {
			if let photoFileName = photoFileName(locationData, photoIndex: photoIndex) {
					completion(image: artPhotoImages.getImage(photoFileName))
			} else {
				completion(image: image)
			}
		} else {
			completion(image: image)
		}
	}
	
	func photoFileName(locationIndex: Int, photoIndex: Int) -> String? {
		var fileName: String?
		if let locationData = locationData(locationIndex) {
			return  photoFileName(locationData, photoIndex: photoIndex)
		} else {
			return nil
		}
	}
	
	
	func photoImage(locationIndex: Int, photoIndex: Int) -> UIImage? {
		var image: UIImage?
		if let locationData = locationData(locationIndex) {
			if let photoFileName = photoFileName(locationData, photoIndex: photoIndex) {
				return artPhotoImages.getImage(photoFileName)
			} else {
				return nil
			}
		} else {
			return nil
		}
	}
	
	func photoThumbNailImage(locationIndex: Int, photoIndex: Int, size: CGSize) -> UIImage? {
		var image: UIImage?
		if let locationData = locationData(locationIndex) {
			if let photoFileName = photoFileName(locationData, photoIndex: photoIndex) {
				return artPhotoImages.getThumbNail(photoFileName, size: size)
			} else {
				return nil
			}
		} else {
			return nil
		}
	}
	
	func photoThumbNailImage(locationIndex: Int, photoIndex: Int, size: CGSize, completion:(image: UIImage?) -> ()) {
		var image: UIImage?
		if let locationData = locationData(locationIndex) {
			if let photoFileName = photoFileName(locationData, photoIndex: photoIndex) {
				completion(image: artPhotoImages.getThumbNail(photoFileName, size: size))
			} else {
				completion(image: image)
			}
		} else {
			completion(image: image)
		}
	}

	
	func locationName(locationIndex: Int) -> String {
		var locationName = String()
		if let locationData = locationData(locationIndex) {
			return locationData.locationName
		}
		return locationName
	}
	
	func photoTitle(locationIndex: Int, photoIndex: Int) -> String {
		var title = String()
		if let locationData = locationData(locationIndex) {
			if let title = locationData.artNameForPhoto(photoIndex) {
				return title
			}
		}
		return title
	}
	
	func locationData(locationIndex: Int) -> LocationData? {
		if locationIndex < locationData.count {
			return locationData[locationIndex]
		}
		return nil
	}
	
	private func photoFileName(locationData: LocationData, photoIndex: Int) -> String? {
		return locationData.photoFileName(photoIndex)
	}
	
}
















