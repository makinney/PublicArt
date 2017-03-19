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
	
	class func create(_ parsePhoto: ParsePhoto, moc: NSManagedObjectContext) -> Photo? {
		if let photo = NSEntityDescription.insertNewObject(forEntityName: ModelEntity.photo, into:moc) as? Photo {
			photo.createdAt = parsePhoto.createdAt!
			photo.objectId = parsePhoto.objectId!
			photo.updatedAt = parsePhoto.updatedAt!
			photo.idArt = parsePhoto.idArt ?? ""
			photo.tnMatch = parsePhoto.tnMatch as NSNumber? ?? false

			if let imageFile = parsePhoto.imageFile {
	//			photo.imageFileName = extractImageFileName(imageFile.name)
                photo.imageFileName = imageFile.name
				photo.imageFileURL = imageFile.url ?? ""
			}
	
			return photo
		}
		return nil
	}
	
	class func update(_ photo: Photo, parsePhoto: ParsePhoto) {
			photo.createdAt = parsePhoto.createdAt!
			photo.objectId = parsePhoto.objectId!
			photo.updatedAt = parsePhoto.updatedAt!
			photo.idArt = parsePhoto.idArt ?? ""
            photo.imageAspectRatio = NSNumber(value: parsePhoto.imageAspectRatio)
			photo.tnMatch = parsePhoto.tnMatch as NSNumber? ?? false

			if let imageFile = parsePhoto.imageFile {
                photo.imageFileName = imageFile.name
				photo.imageFileURL = imageFile.url ?? ""

			}
	}
	
//	class fileprivate func extractImageFileName(_ source: String) -> String {
//		var imageFileName = ""
//		let delimiter = "-"
//		if let lastDelimiter = source.range(of: delimiter, options: NSString.CompareOptions.backwards) {
//			imageFileName = source[lastDelimiter.upperBound..<source.endIndex]
//		}
//		// println("extracted image file name \(imageFileName)")
//		return imageFileName
//	}
}
