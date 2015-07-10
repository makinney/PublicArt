//
//  PhotoExtension.swift
//  ArtCity
//
//  Created by Michael Kinney on 1/21/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import Foundation
import CoreData

extension Photo {
	
	class func create(parsePhoto: ParsePhoto, moc: NSManagedObjectContext) -> Photo? {
		if let photo = NSEntityDescription.insertNewObjectForEntityForName(ModelEntity.photo, inManagedObjectContext:moc) as? Photo {
			photo.createdAt = parsePhoto.createdAt!
			photo.objectId = parsePhoto.objectId!
			photo.updatedAt = parsePhoto.updatedAt!
			photo.idArt = parsePhoto.idArt ?? ""
			photo.imageAspectRatio = parsePhoto.imageAspectRatio
			photo.tnMatch = parsePhoto.tnMatch ?? false

			if let imageFile = parsePhoto.imageFile {
				photo.imageFileName = extractImageFileName(imageFile.name)
				photo.imageFileURL = imageFile.url ?? ""
			}
	
			return photo
		}
		return nil
	}
	
	class func update(photo: Photo, parsePhoto: ParsePhoto) {
			photo.createdAt = parsePhoto.createdAt!
			photo.objectId = parsePhoto.objectId!
			photo.updatedAt = parsePhoto.updatedAt!
			photo.idArt = parsePhoto.idArt ?? ""
			photo.imageAspectRatio = parsePhoto.imageAspectRatio
			photo.tnMatch = parsePhoto.tnMatch ?? false

			if let imageFile = parsePhoto.imageFile {
				photo.imageFileName = extractImageFileName(imageFile.name)
				photo.imageFileURL = imageFile.url ?? ""

			}
	}
	
	class private func extractImageFileName(source: String) -> String {
		var imageFileName = ""
		let delimiter = "-"
		if let lastDelimiter = source.rangeOfString(delimiter, options: NSStringCompareOptions.BackwardsSearch) {
			imageFileName = source[lastDelimiter.endIndex..<source.endIndex]
		}
		// println("extracted image file name \(imageFileName)")
		return imageFileName
	}
}