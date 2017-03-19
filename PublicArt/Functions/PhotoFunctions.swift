//
//  PhotoFunctions.swift
//  PublicArt
//
//  Created by Michael Kinney on 7/15/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import Foundation


func convertToSortedArray(_ set: Set<Photo>) -> [Photo] {
	var photos = [Photo]()
	let sortedPhotoSet = set.sorted(by: { $0.imageFileName < $1.imageFileName }) // FIXME: sorted return the set or not ?
	for photo in sortedPhotoSet {
		photos.append(photo)
	}
	return photos
}
//
//func sortThumbnailPhotoToFirstPositionIn(_ photos: [Photo]) -> [Photo] {
//	var photos = photos
//	for (index, photo) in photos.enumerated() {
//		if photo.tnMatch == true {
//			photos.remove(at: index)
//			photos.insert(photo, at: 0)
//			break
//		}
//	}
//	return photos
//}


func thumbNailsHighResolutionVersionIn(_ art: Art) -> Photo? {
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

func thumbNailsHighResolutionVersionIn(_ photos: [Photo]) -> Photo? {
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

