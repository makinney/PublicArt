//
//  PhotoFunctions.swift
//  PublicArt
//
//  Created by Michael Kinney on 7/15/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation


func convertToSortedArray(set: Set<Photo>) -> [Photo] {
	var photos = [Photo]()
	let sortedPhotoSet = set.sort({ $0.imageFileName < $1.imageFileName })
	for photo in sortedPhotoSet {
		photos.append(photo)
	}
	return photos
}

func sortThumbnailPhotoToFirstPositionIn(photos: [Photo]) -> [Photo] {
	var photos = photos
	for (index, photo) in photos.enumerate() {
		if photo.tnMatch == true {
			photos.removeAtIndex(index)
			photos.insert(photo, atIndex: 0)
			break
		}
	}
	return photos
}


func thumbNailsHighResolutionVersionIn(art: Art) -> Photo? {
	var highResPhoto: Photo?
	if let photoSet: Set<Photo> = art.photos as? Set {
		for photo in photoSet {
			if photo.tnMatch == true {
				highResPhoto = photo
				break
			}
		}
	}
	return highResPhoto
}

func thumbNailsHighResolutionVersionIn(photos: [Photo]) -> Photo? {
	var highResPhoto: Photo?
	let photos = photos
	for photo in photos {
		if photo.tnMatch == true {
			highResPhoto = photo
			break
		}
	}
	return highResPhoto
}

